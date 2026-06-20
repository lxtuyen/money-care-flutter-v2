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
  final GetGoalPredictionUseCase getGoalPredictionUseCase;
  final GetGoalPredictionsUseCase getGoalPredictionsUseCase;
  final ActivateSavingGoalUseCase activateSavingGoalUseCase;
  final PauseSavingGoalUseCase pauseSavingGoalUseCase;
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
    required this.getGoalPredictionUseCase,
    required this.getGoalPredictionsUseCase,
    required this.activateSavingGoalUseCase,
    required this.pauseSavingGoalUseCase,
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
  final Map<int, Future<SavingGoalReportModel?>> _activeReportFutures = {};
  Rxn<GoalAchievementPredictionModel> goalPrediction =
      Rxn<GoalAchievementPredictionModel>();
  Rxn<GoalAchievementPredictionSummaryModel> goalPredictionSummary =
      Rxn<GoalAchievementPredictionSummaryModel>();
  RxBool isLoadingPrediction = false.obs;
  final Map<int, Future<GoalAchievementPredictionModel?>> _activePredictionFutures = {};

  RxMap<int, SavingGoalReportModel> goalReports = <int, SavingGoalReportModel>{}.obs;
  RxMap<int, GoalAchievementPredictionModel> goalPredictions = <int, GoalAchievementPredictionModel>{}.obs;
  RxBool isLoadingMultiReports = false.obs;

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
    goalPrediction.value = null;
  }

  Future<void> loadGoals([int? manualUserId]) async {
    final uid = manualUserId ?? appController.userId.value;
    if (uid == null || uid <= 0) return;

    isLoadingGoals.value = true;
    final result = await getSavingGoalsByUserUseCase(uid);
    result.fold(_handleFailure, (list) {
      goals.assignAll(list.where((g) => !g.isCompleted).toList());
      completedGoals.assignAll(list.where((g) => g.isCompleted).toList());

      // Auto-set currentGoal to the first active goal, or if none, the first paused goal
      final activeGoal = goals.firstWhereOrNull((g) => g.isActive) ??
          goals.firstWhereOrNull((g) => g.isPaused);
      if (activeGoal != null) {
        _syncCurrentGoal(activeGoal);
      } else {
        _clearCurrentGoal();
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
    // Selection disabled
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
        loadGoalPrediction(goal.id);
      },
    );
    isLoadingCurrent.value = false;
  }

  Future<bool> selectGoal(int userId, int id) async {
    return true; // Selection disabled
  }

  Future<void> saveSelection() async {
    // Selection disabled
  }

  Future<void> confirmSelectedGoal() async {
    // Selection disabled
  }

  Future<void> deselectGoal() async {
    _clearCurrentGoal();
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

  List<SavingGoalEntity> get activeGoals =>
      goals.where((g) => g.isActive).toList();

  List<SavingGoalEntity> get pausedGoals =>
      goals.where((g) => g.isPaused).toList();

  int get activeGoalCount => activeGoals.length;

  Future<bool> activateGoal(int goalId) async {
    isLoadingGoals.value = true;
    final result = await activateSavingGoalUseCase(goalId);
    final isSuccess = await result.fold(
      (failure) async {
        _handleFailure(failure);
        return false;
      },
      (updated) async {
        final index = goals.indexWhere((f) => f.id == goalId);
        if (index != -1) {
          goals[index] = updated;
          goals.refresh();
        }
        if (currentGoal.value?.id == goalId) {
          currentGoal.value = updated;
        }
        AppHelperFunction.showSuccessSnackBar('Kích hoạt mục tiêu thành công');
        final userId = appController.userId.value;
        if (userId != null) {
          await loadGoals(userId);
        }
        return true;
      },
    );
    isLoadingGoals.value = false;
    return isSuccess;
  }

  Future<bool> pauseGoal(int goalId) async {
    isLoadingGoals.value = true;
    final result = await pauseSavingGoalUseCase(goalId);
    final isSuccess = await result.fold(
      (failure) async {
        _handleFailure(failure);
        return false;
      },
      (updated) async {
        final index = goals.indexWhere((f) => f.id == goalId);
        if (index != -1) {
          goals[index] = updated;
          goals.refresh();
        }
        if (currentGoal.value?.id == goalId) {
          currentGoal.value = updated;
        }
        AppHelperFunction.showSuccessSnackBar('Tạm dừng mục tiêu thành công');
        final userId = appController.userId.value;
        if (userId != null) {
          await loadGoals(userId);
        }
        return true;
      },
    );
    isLoadingGoals.value = false;
    return isSuccess;
  }

  Future<SavingGoalReportModel?> loadGoalReport(int id) async {
    if (id <= 0) return null;

    if (_activeReportFutures.containsKey(id)) {
      return _activeReportFutures[id];
    }

    isLoadingReport.value = true;

    final future = getSavingGoalReportUseCase(id)
        .then((result) {
          return result.fold(
            (failure) {
              _handleFailure(failure);
              return null;
            },
            (report) {
              if (id == currentGoal.value?.id) {
                goalReport.value = report;
              }
              goalReports[id] = report;
              return report;
            },
          );
        })
        .whenComplete(() {
          isLoadingReport.value = false;
          _activeReportFutures.remove(id);
        });

    _activeReportFutures[id] = future;
    return future;
  }

  Future<GoalAchievementPredictionModel?> loadGoalPrediction(int id) async {
    if (id <= 0) return null;

    if (_activePredictionFutures.containsKey(id)) {
      return _activePredictionFutures[id];
    }

    isLoadingPrediction.value = true;
    if (id == currentGoal.value?.id && goalPrediction.value?.goalId != id) {
      goalPrediction.value = null;
    }

    final future = getGoalPredictionUseCase(id)
        .then((result) {
          return result.fold(
            (failure) {
              _handleFailure(failure);
              return null;
            },
            (prediction) {
              if (id == currentGoal.value?.id) {
                goalPrediction.value = prediction;
              }
              goalPredictions[id] = prediction;
              return prediction;
            },
          );
        })
        .whenComplete(() {
          isLoadingPrediction.value = false;
          _activePredictionFutures.remove(id);
        });

    _activePredictionFutures[id] = future;
    return future;
  }

  Future<void> loadMultiGoalData() async {
    isLoadingMultiReports.value = true;

    try {
      await loadGoals();
      if (goals.isEmpty) return;

      // 1. Load predictions in batch
      final summary = await loadGoalPredictions();
      if (summary != null) {
        for (final pred in summary.predictions) {
          goalPredictions[pred.goalId] = pred;
        }
      }

      // 2. Load reports in parallel for all active goals
      await Future.wait(
        goals.map((goal) => loadGoalReport(goal.id)),
      );
    } catch (e) {
      _showError('Lỗi khi tải dữ liệu thống kê mục tiêu: $e');
    } finally {
      isLoadingMultiReports.value = false;
    }
  }

  Future<GoalAchievementPredictionSummaryModel?> loadGoalPredictions() async {
    final result = await getGoalPredictionsUseCase();
    return result.fold(
      (failure) {
        _handleFailure(failure);
        return null;
      },
      (summary) {
        goalPredictionSummary.value = summary;
        return summary;
      },
    );
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
      loadGoalPrediction(id);

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

      await walletController.deleteWallet(sourceWalletId, showSuccessMessage: false);

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
