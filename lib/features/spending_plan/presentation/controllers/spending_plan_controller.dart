import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/spending_plan/domain/usecases/usecases.dart';

class SpendingPlanController extends GetxController {
  final GetSpendingPlansUseCase getSpendingPlansUseCase;
  final GetActiveSpendingPlanUseCase getActiveSpendingPlanUseCase;
  final GetSpendingPlanUseCase getSpendingPlanUseCase;
  final CreateSpendingPlanUseCase createSpendingPlanUseCase;
  final UpdateSpendingPlanUseCase updateSpendingPlanUseCase;
  final DeleteSpendingPlanUseCase deleteSpendingPlanUseCase;
  final ActivateSpendingPlanUseCase activateSpendingPlanUseCase;
  final PauseSpendingPlanUseCase pauseSpendingPlanUseCase;
  final GetActiveSpendingPlanStatisticsUseCase
  getActiveSpendingPlanStatisticsUseCase;
  final AddPlanExpenseUseCase addPlanExpenseUseCase;
  final UpdatePlanExpenseUseCase updatePlanExpenseUseCase;
  final RemovePlanExpenseUseCase removePlanExpenseUseCase;

  SpendingPlanController({
    required this.getSpendingPlansUseCase,
    required this.getActiveSpendingPlanUseCase,
    required this.getSpendingPlanUseCase,
    required this.createSpendingPlanUseCase,
    required this.updateSpendingPlanUseCase,
    required this.deleteSpendingPlanUseCase,
    required this.activateSpendingPlanUseCase,
    required this.pauseSpendingPlanUseCase,
    required this.getActiveSpendingPlanStatisticsUseCase,
    required this.addPlanExpenseUseCase,
    required this.updatePlanExpenseUseCase,
    required this.removePlanExpenseUseCase,
  });

  final plans = <SpendingPlanEntity>[].obs;
  final activePlan = Rxn<SpendingPlanEntity>();
  final selectedPlan = Rxn<SpendingPlanEntity>();
  final statsSummary = Rxn<SpendingPlanStatsEntity>();
  final isLoading = false.obs;
  final isLoadingStats = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final selectedPlanIndex = (-1).obs;
  Future<void>? _activePlanRequest;
  Future<void>? _statsSummaryRequest;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
    loadActivePlan();
  }

  Future<void> loadPlans() async {
    isLoading.value = true;
    final result = await getSpendingPlansUseCase();
    result.fold(_handleFailure, (items) {
      plans.assignAll(items);
      final activeIdx = plans.indexWhere((p) => p.isActive);
      selectedPlanIndex.value = activeIdx;
    });
    isLoading.value = false;
  }

  void updateSelectedPlanIndex(int index) {
    if (selectedPlanIndex.value == index) {
      selectedPlanIndex.value = -1;
    } else {
      selectedPlanIndex.value = index;
    }
  }

  Future<void> saveSelection() async {
    final currentActiveIndex = plans.indexWhere((p) => p.isActive);
    if (selectedPlanIndex.value == currentActiveIndex) {
      return;
    }

    if (selectedPlanIndex.value == -1) {
      if (currentActiveIndex != -1) {
        final currentActive = plans[currentActiveIndex];
        await pausePlan(currentActive.id);
      }
    } else if (plans.isNotEmpty &&
        selectedPlanIndex.value >= 0 &&
        selectedPlanIndex.value < plans.length) {
      final selected = plans[selectedPlanIndex.value];
      await activatePlan(selected.id);
    }
  }

  Future<void> loadActivePlan() async {
    await _loadActivePlanOnly();
    await loadStatsSummary();
  }

  Future<void> _loadActivePlanOnly() {
    final runningRequest = _activePlanRequest;
    if (runningRequest != null) return runningRequest;

    final request = () async {
      final result = await getActiveSpendingPlanUseCase();
      result.fold(
        (failure) {
          _handleFailure(failure);
        },
        (plan) {
          activePlan.value = plan;
        },
      );
    }();

    _activePlanRequest = request;
    request.whenComplete(() {
      if (identical(_activePlanRequest, request)) {
        _activePlanRequest = null;
      }
    });
    return request;
  }

  Future<void> loadStatsSummary({bool loadActiveIfMissing = false}) async {
    if (loadActiveIfMissing && activePlan.value == null) {
      await _loadActivePlanOnly();
    }

    if (activePlan.value == null) {
      statsSummary.value = null;
      return;
    }

    final runningRequest = _statsSummaryRequest;
    if (runningRequest != null) return runningRequest;

    isLoadingStats.value = true;
    final request = () async {
      final result = await getActiveSpendingPlanStatisticsUseCase();
      result.fold(
        (failure) {
          statsSummary.value = null;
        },
        (stats) {
          statsSummary.value = stats;
        },
      );
    }();

    _statsSummaryRequest = request;
    await request.whenComplete(() {
      if (identical(_statsSummaryRequest, request)) {
        _statsSummaryRequest = null;
      }
      isLoadingStats.value = false;
    });
  }

  Future<void> loadPlan(int id) async {
    isLoading.value = true;
    final result = await getSpendingPlanUseCase(id);
    result.fold(_handleFailure, (plan) {
      selectedPlan.value = plan;
    });
    isLoading.value = false;
  }

  Future<bool> createPlan(CreateSpendingPlanRequest request) async {
    return _runSavingAction(() => createSpendingPlanUseCase(request), (plan) {
      selectedPlan.value = plan;
      plans.insert(0, plan);
      AppHelperFunction.showSuccessSnackBar('Tạo kế hoạch chi tiêu thành công');
      return true;
    });
  }

  Future<bool> updatePlan(int id, UpdateSpendingPlanRequest request) async {
    return _runSavingAction(() => updateSpendingPlanUseCase(id, request), (
      plan,
    ) {
      selectedPlan.value = plan;
      _replacePlan(plan);
      if (activePlan.value?.id == plan.id) {
        activePlan.value = plan;
      }
      AppHelperFunction.showSuccessSnackBar(
        'Cập nhật kế hoạch chi tiêu thành công',
      );
      return true;
    });
  }

  Future<bool> deletePlan(int id) async {
    return _runSavingAction(() => deleteSpendingPlanUseCase(id), (_) {
      plans.removeWhere((item) => item.id == id);
      if (activePlan.value?.id == id) {
        activePlan.value = null;
        statsSummary.value = null;
      }
      if (selectedPlan.value?.id == id) {
        selectedPlan.value = null;
      }
      final activeIdx = plans.indexWhere((p) => p.isActive);
      selectedPlanIndex.value = activeIdx;
      AppHelperFunction.showSuccessSnackBar('Đã xóa kế hoạch chi tiêu');
      return true;
    });
  }

  Future<bool> activatePlan(int id) async {
    return _runSavingAction(() => activateSpendingPlanUseCase(id), (plan) {
      activePlan.value = plan;
      selectedPlan.value = plan;
      _replacePlan(plan);
      for (var i = 0; i < plans.length; i++) {
        final item = plans[i];
        if (item.id != plan.id && item.status == 'active') {
          plans[i] = item.copyWith(status: 'paused');
        }
      }
      plans.refresh();
      selectedPlanIndex.value = plans.indexWhere((p) => p.id == plan.id);
      loadStatsSummary();
      AppHelperFunction.showSuccessSnackBar('Đã áp dụng kế hoạch');
      return true;
    });
  }

  Future<bool> pausePlan(int id) async {
    return _runSavingAction(() => pauseSpendingPlanUseCase(id), (plan) {
      _replacePlan(plan);
      if (activePlan.value?.id == plan.id) {
        activePlan.value = null;
        statsSummary.value = null;
      }
      selectedPlan.value = plan;
      selectedPlanIndex.value = -1;
      AppHelperFunction.showSuccessSnackBar('Đã tạm dừng kế hoạch');
      return true;
    });
  }

  Future<bool> addPlanExpense(
    int planId,
    CreateEstimatedExpenseRequest request, {
    bool showSuccessMessage = true,
  }) async {
    return _runSavingAction(() => addPlanExpenseUseCase(planId, request), (
      updatedPlan,
    ) {
      _syncUpdatedPlan(planId, updatedPlan);
      if (showSuccessMessage) {
        AppHelperFunction.showSuccessSnackBar(
          'Đã thêm khoản chi dự kiến thành công',
        );
      }
      return true;
    });
  }

  Future<bool> updatePlanExpense(
    int planId,
    int expenseId,
    CreateEstimatedExpenseRequest request, {
    bool showSuccessMessage = true,
  }) async {
    return _runSavingAction(
      () => updatePlanExpenseUseCase(planId, expenseId, request),
      (updatedPlan) {
        _syncUpdatedPlan(planId, updatedPlan);
        if (showSuccessMessage) {
          AppHelperFunction.showSuccessSnackBar(
            'Đã cập nhật khoản chi dự kiến',
          );
        }
        return true;
      },
    );
  }

  Future<bool> removePlanExpense(int planId, int expenseId) async {
    return _runSavingAction(() => removePlanExpenseUseCase(planId, expenseId), (
      updatedPlan,
    ) {
      _syncUpdatedPlan(planId, updatedPlan);
      AppHelperFunction.showSuccessSnackBar('Đã xóa khoản chi dự kiến');
      return true;
    });
  }

  Future<bool> _runSavingAction<T>(
    Future<Either<Failure, T>> Function() action,
    bool Function(T value) onSuccess,
  ) async {
    isSaving.value = true;
    try {
      final result = await action();
      return result.fold((failure) {
        _handleFailure(failure);
        return false;
      }, onSuccess);
    } finally {
      isSaving.value = false;
    }
  }

  void _syncUpdatedPlan(int planId, SpendingPlanEntity updatedPlan) {
    selectedPlan.value = updatedPlan;
    _replacePlan(updatedPlan);
    if (activePlan.value?.id == planId) {
      activePlan.value = updatedPlan;
      loadStatsSummary();
    }
  }

  void _replacePlan(SpendingPlanEntity plan) {
    final index = plans.indexWhere((item) => item.id == plan.id);
    if (index >= 0) {
      plans[index] = plan;
    } else {
      plans.insert(0, plan);
    }
  }

  void _handleFailure(Failure failure) {
    errorMessage.value = failure.message;
    AppHelperFunction.showErrorSnackBar(failure.message);
  }
}
