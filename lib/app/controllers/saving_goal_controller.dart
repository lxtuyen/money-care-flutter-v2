import 'package:get/get.dart';

import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
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
  final Set<int> _notifiedGoalIds = {};

  Rxn<ExpiredGoalInfoModel> expiredGoal = Rxn<ExpiredGoalInfoModel>();
  RxBool hasExpiredGoal = false.obs;
  Rxn<SavingGoalReportModel> goalReport = Rxn<SavingGoalReportModel>();
  RxBool isLoadingReport = false.obs;
  Future<SavingGoalReportModel?>? _activeReportFuture;
  int? _activeReportId;

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
    if (goal.isCompleted) {
      _clearCurrentGoal();
      return;
    }
    currentGoal.value = goal;
    goalId.value = goal.id;
  }

  void _clearCurrentGoal() {
    currentGoal.value = null;
    goalId.value = 0;
    selectedGoalIndex.value = -1;
    goalReport.value = null;
  }

  Future<void> loadGoals([int? manualUserId]) async {
    final uid = manualUserId ?? appController.userId.value;
    if (uid == null || uid <= 0) return;

    isLoadingGoals.value = true;
    final result = await getSavingGoalsByUserUseCase(uid);
    result.fold(_handleFailure, (list) {
      goals.assignAll(list.where((g) => !g.isCompleted).toList());
      completedGoals.assignAll(list.where((g) => g.isCompleted).toList());

      final activeGoal = goals.firstWhereOrNull((g) => g.isSelected ?? false);
      if (activeGoal != null) {
        _syncCurrentGoal(activeGoal);
      } else if (goalId.value > 0) {
        final matchingGoal = goals.firstWhereOrNull(
          (g) => g.id == goalId.value,
        );
        if (matchingGoal != null) {
          _syncCurrentGoal(matchingGoal);
        }
      }

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
    result.fold(
      (failure) {
        _handleFailure(failure);
        _clearCurrentGoal();
      },
      (goal) {
        currentGoal.value = goal;
        loadGoalReport(goal.id);
      },
    );
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

  Future<void> saveSelection() async {
    final currentUserId = appController.userId.value ?? 0;
    if (currentUserId == 0) return;

    if (selectedGoalIndex.value == -1) {
      await deselectGoal();
    } else if (goals.isNotEmpty &&
        selectedGoalIndex.value >= 0 &&
        selectedGoalIndex.value < goals.length) {
      final selectedGoal = goals[selectedGoalIndex.value];
      if (currentGoal.value?.id != selectedGoal.id) {
        await selectGoal(currentUserId, selectedGoal.id);
      }
    }
  }

  Future<void> confirmSelectedGoal() async {
    await saveSelection();
    Get.back();
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

      if (Get.isRegistered<StatisticsController>()) {
        Get.find<StatisticsController>().refreshStatisticsData(currentUserId);
      }
      if (Get.isRegistered<TransactionController>()) {
        Get.find<TransactionController>().refreshAllData(currentUserId);
      }
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
          deselectGoal();
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
    // Sử dụng showSnackBar thay vì showErrorSnackBar để tự động nhận diện loại thông báo
    // (VD: nếu message chứa "thành công" thì hiện màu xanh)
    AppHelperFunction.showSnackBar(message);
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

  Future<SavingGoalReportModel?> loadGoalReport(int id) async {
    if (id <= 0) return null;

    if (_activeReportId == id && _activeReportFuture != null) {
      return _activeReportFuture;
    }

    _activeReportId = id;
    isLoadingReport.value = true;

    _activeReportFuture = getSavingGoalReportUseCase(id).then((result) {
      return result.fold(
        (failure) {
          _handleFailure(failure);
          return null;
        },
        (report) {
          goalReport.value = report;
          if ((report.isCompleted || report.isTargetAchieved) &&
              !report.completionNotified &&
              !_notifiedGoalIds.contains(id) &&
              !(Get.isDialogOpen ?? false)) {
            _notifiedGoalIds.add(id);
            GoalCompletionDialog.show(report);
          }
          return report;
        },
      );
    }).whenComplete(() {
      isLoadingReport.value = false;
      _activeReportFuture = null;
      _activeReportId = null;
    });

    return _activeReportFuture;
  }

  Future<void> completeGoalEarly(int id) async {
    final result = await updateSavingGoalUseCase(
      SavingGoalDto(id: id, isCompleted: true),
    );

    result.fold(_handleFailure, (updated) async {
      goals.removeWhere((g) => g.id == updated.id);
      goals.refresh();

      if (currentGoal.value?.id == updated.id) {
        _clearCurrentGoal();
      }

      loadGoalReport(id);

      final userId = appController.userId.value;
      if (userId != null) {
        if (Get.isRegistered<StatisticsController>()) {
          Get.find<StatisticsController>().refreshStatisticsData(userId);
        }
        if (Get.isRegistered<TransactionController>()) {
          Get.find<TransactionController>().refreshAllData(userId);
        }
      }

      if (!completedGoals.any((g) => g.id == updated.id)) {
        completedGoals.add(updated);
      }
    });
  }

  Future<void> completeGoalWithTransfer({
    required int goalId,
    required int sourceWalletId,
    required int destinationWalletId,
    required double amount,
  }) async {
    isLoadingCurrent.value = true;
    try {
      final walletController = Get.find<WalletController>();
      final categoryController = Get.find<UserCategoryController>();

      if (amount > 0) {
        final categoryId = await categoryController
            .getOrCreateTransferCategory();

        await walletController.transfer(
          sourceWalletId,
          destinationWalletId,
          amount,
          note: 'Chuyển tiền hoàn thành mục tiêu',
          categoryId: categoryId,
        );
      }

      await completeGoalEarly(goalId);

      await walletController.deleteWallet(sourceWalletId);

      AppHelperFunction.showSuccessSnackBar(
        'Đã chuyển tiền và đóng ví mục tiêu thành công',
      );
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi khi hoàn thành mục tiêu: $e');
    } finally {
      isLoadingCurrent.value = false;
    }
  }
}
