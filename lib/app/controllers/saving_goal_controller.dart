import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';

import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/usecases/usecases.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/goal_completion_dialog.dart';

class SavingGoalController extends GetxController {
  final GetSavingGoalsByUserUseCase getSavingGoalsByUserUseCase;
  final GetSavingGoalUseCase getSavingGoalUseCase;
  final UpdateSavingGoalUseCase updateSavingGoalUseCase;
  final DeleteSavingGoalUseCase deleteSavingGoalUseCase;
  final SelectSavingGoalUseCase selectSavingGoalUseCase;
  final CheckExpiredSavingGoalUseCase checkExpiredSavingGoalUseCase;
  final MarkAsNotifiedUseCase markAsNotifiedUseCase;
  final ExtendSavingGoalUseCase extendSavingGoalUseCase;
  final GetSavingGoalReportUseCase getSavingGoalReportUseCase;
  final AppController appController = Get.find<AppController>();

  SavingGoalController({
    required this.getSavingGoalsByUserUseCase,
    required this.getSavingGoalUseCase,
    required this.updateSavingGoalUseCase,
    required this.deleteSavingGoalUseCase,
    required this.selectSavingGoalUseCase,
    required this.checkExpiredSavingGoalUseCase,
    required this.markAsNotifiedUseCase,
    required this.extendSavingGoalUseCase,
    required this.getSavingGoalReportUseCase,
  });

  RxList<SavingGoalEntity> goals = <SavingGoalEntity>[].obs;
  RxList<SavingGoalEntity> completedGoals = <SavingGoalEntity>[].obs;
  Rxn<SavingGoalEntity> currentGoal = Rxn<SavingGoalEntity>();
  RxBool isLoadingGoals = false.obs;
  RxBool isLoadingCurrent = false.obs;
  RxString? errorMessage = RxString('');
  var goalId = 0.obs;
  RxInt selectedGoalIndex = 0.obs;

  Rxn<ExpiredGoalInfoModel> expiredGoal = Rxn<ExpiredGoalInfoModel>();
  RxBool hasExpiredGoal = false.obs;
  Rxn<SavingGoalReportModel> goalReport = Rxn<SavingGoalReportModel>();
  RxBool isLoadingReport = false.obs;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();

    ever(authController.user, (user) {
      if (user?.savingGoal != null) {
        _syncCurrentGoal(user!.savingGoal!);
      } else {
        _clearCurrentGoal();
      }
    });

    if (authController.user.value?.savingGoal != null) {
      _syncCurrentGoal(authController.user.value!.savingGoal!);
    } else {
      _clearCurrentGoal();
    }

    ever(goalId, (id) {
      if (id > 0) {
        loadGoalById();
      }
    });
  }

  void _syncCurrentGoal(SavingGoalEntity goal) {
    currentGoal.value = goal;
    goalId.value = goal.id;
  }

  void _clearCurrentGoal() {
    currentGoal.value = null;
    goalId.value = 0;
    selectedGoalIndex.value = -1;
  }

  Future<void> loadGoals([int? manualUserId]) async {
    final uid = manualUserId ?? appController.userId.value;
    if (uid == null || uid <= 0) return;

    isLoadingGoals.value = true;
    final result = await getSavingGoalsByUserUseCase(uid);
    result.fold(_handleFailure, (list) {
      goals.assignAll(list.where((g) => !g.isCompleted).toList());
      completedGoals.assignAll(list.where((g) => g.isCompleted).toList());

      if (goalId.value > 0) {
        selectedGoalIndex.value = goals.indexWhere((f) => f.id == goalId.value);
      }
    });
    isLoadingGoals.value = false;
  }

  Future<void> loadUserAndGoals() async {
    await loadGoals();
  }

  Future<void> initializeSelectGoal() async {
    await loadGoals();
  }

  void updateSelectedGoalIndex(int index) {
    if (selectedGoalIndex.value == index) {
      selectedGoalIndex.value = -1;
    } else {
      selectedGoalIndex.value = index;
    }
  }

  void goToCreateGoal() {
    Get.toNamed(RoutePath.createSavingGoal);
  }

  Future<void> loadGoalById() async {
    isLoadingCurrent.value = true;
    final result = await getSavingGoalUseCase(goalId.value);
    result.fold(_handleFailure, (goal) {
      currentGoal.value = goal;
      loadGoalReport(goal.id);
    });
    isLoadingCurrent.value = false;
  }

  Future<bool> selectGoal(int userId, int id) async {
    isLoadingCurrent.value = true;
    final result = await selectSavingGoalUseCase(userId, id);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (selected) {
        currentGoal.value = selected;
        goalId.value = id;

        final authController = Get.find<AuthController>();
        if (authController.user.value != null) {
          authController.user.value = authController.user.value!.copyWith(
            savingGoal: selected,
          );
        }

        loadGoals(userId);
        return true;
      },
    );
    isLoadingCurrent.value = false;
    return isSuccess;
  }

  Future<void> confirmSelectedGoal() async {
    final currentUserId = appController.userId.value ?? 0;

    if (selectedGoalIndex.value == -1) {
      await deselectGoal();
      Get.toNamed(RoutePath.main);
      return;
    }

    if (goals.isEmpty || selectedGoalIndex.value < 0) return;

    final selectedGoal = goals[selectedGoalIndex.value];
    final isSuccess = await selectGoal(currentUserId, selectedGoal.id);
    if (!isSuccess) {
      return;
    }

    Get.toNamed(RoutePath.main);
  }

  Future<void> deselectGoal() async {
    currentGoal.value = null;
    goalId.value = 0;

    final authController = Get.find<AuthController>();
    if (authController.user.value != null) {
      authController.user.value = authController.user.value!.copyWith(
        savingGoal: null,
      );
    }

    final currentUserId = appController.userId.value;
    if (currentUserId != null) {
      await selectSavingGoalUseCase(currentUserId, 0);
    }
  }

  Future<bool> updateGoal(SavingGoalDto dto) async {
    isLoadingGoals.value = true;
    final result = await updateSavingGoalUseCase(dto);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (updated) {
        final index = goals.indexWhere((f) => f.id == dto.id);
        if (index != -1) {
          if (updated.isCompleted) {
            goals.removeAt(index);
          } else {
            goals[index] = updated;
          }
          goals.refresh();
        }

        if (currentGoal.value?.id == dto.id) {
          currentGoal.value = updated;
        }
        AppHelperFunction.showSuccessSnackBar('Cập nhật mục tiêu thành công');
        return true;
      },
    );
    isLoadingGoals.value = false;
    return isSuccess;
  }

  Future<bool> deleteGoal(int id) async {
    isLoadingGoals.value = true;
    final result = await deleteSavingGoalUseCase(id);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (_) {
        goals.removeWhere((f) => f.id == id);
        goals.refresh();

        if (currentGoal.value?.id == id) {
          currentGoal.value = null;
          goalId.value = 0;
        }
        AppHelperFunction.showSuccessSnackBar('Xóa mục tiêu thành công');
        return true;
      },
    );
    isLoadingGoals.value = false;
    return isSuccess;
  }

  void _handleFailure(Failure failure) {
    _showError(failure.message);
  }

  void _showError(String message) {
    errorMessage?.value = message;
    AppHelperFunction.showErrorSnackBar(message);
  }

  int get currentGoalId => goalId.value;

  SavingGoalEntity? get selectedGoal => currentGoal.value;

  List<SavingGoalEntity> get expiredSavingGoals {
    return goals.where((f) => f.isExpired).toList()..sort(
      (a, b) => (b.endDate ?? DateTime(0)).compareTo(a.endDate ?? DateTime(0)),
    );
  }

  List<SavingGoalEntity> get finishedSavingGoals {
    final combined = [...expiredSavingGoals, ...completedGoals];

    combined.sort((a, b) {
      final dateA = a.endDate ?? DateTime(0);
      final dateB = b.endDate ?? DateTime(0);
      return dateB.compareTo(dateA);
    });

    return combined;
  }

  Future<void> checkExpiredSavingGoal(int userId) async {
    final result = await checkExpiredSavingGoalUseCase(userId);
    result.fold((_) {}, (data) {
      hasExpiredGoal.value = data.hasExpiredGoal;
      expiredGoal.value = data.expiredGoal;
    });
  }

  Future<void> markAsNotified(int id) async {
    await markAsNotifiedUseCase(id);
    hasExpiredGoal.value = false;
    expiredGoal.value = null;
  }

  Future<bool> extendGoal(
    int id,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) async {
    final result = await extendSavingGoalUseCase(
      id,
      newEndDate,
      newStartDate: newStartDate,
    );
    return result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (updated) {
        hasExpiredGoal.value = false;
        expiredGoal.value = null;
        currentGoal.value = updated;
        AppHelperFunction.showSuccessSnackBar('Gia hạn mục tiêu thành công');
        return true;
      },
    );
  }

  Future<void> loadGoalReport(int id) async {
    if (id <= 0) return;
    isLoadingReport.value = true;
    final result = await getSavingGoalReportUseCase(id);
    result.fold(_handleFailure, (report) {
      goalReport.value = report;
      if (report.isCompleted && !report.completionNotified) {
        GoalCompletionDialog.show(report);
      }
    });
    isLoadingReport.value = false;
  }

  Future<void> completeGoalEarly(int id) async {
    final result = await updateSavingGoalUseCase(
      SavingGoalDto(id: id, isCompleted: true),
    );

    result.fold(_handleFailure, (updated) {
      goals.removeWhere((g) => g.id == updated.id);
      goals.refresh();

      loadGoalReport(id);
      if (currentGoal.value?.id == id) {
        currentGoal.value = updated;
      }

      if (!completedGoals.any((g) => g.id == updated.id)) {
        completedGoals.add(updated);
      }
    });
  }
}
