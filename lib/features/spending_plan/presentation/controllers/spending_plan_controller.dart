import 'package:get/get.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/data/datasources/spending_plan_remote_datasource.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/usecases/usecases.dart';

class SpendingPlanController extends GetxController {
  final GetSpendingPlansUseCase getSpendingPlansUseCase;
  final GetActiveSpendingPlanUseCase getActiveSpendingPlanUseCase;
  final GetSpendingPlanUseCase getSpendingPlanUseCase;
  final CreateSpendingPlanUseCase createSpendingPlanUseCase;
  final UpdateSpendingPlanUseCase updateSpendingPlanUseCase;
  final DeleteSpendingPlanUseCase deleteSpendingPlanUseCase;
  final ActivateSpendingPlanUseCase activateSpendingPlanUseCase;
  final ArchiveSpendingPlanUseCase archiveSpendingPlanUseCase;

  SpendingPlanController({
    required this.getSpendingPlansUseCase,
    required this.getActiveSpendingPlanUseCase,
    required this.getSpendingPlanUseCase,
    required this.createSpendingPlanUseCase,
    required this.updateSpendingPlanUseCase,
    required this.deleteSpendingPlanUseCase,
    required this.activateSpendingPlanUseCase,
    required this.archiveSpendingPlanUseCase,
  });

  final plans = <SpendingPlanEntity>[].obs;
  final activePlan = Rxn<SpendingPlanEntity>();
  final selectedPlan = Rxn<SpendingPlanEntity>();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

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
    });
    isLoading.value = false;
  }

  Future<void> loadActivePlan() async {
    final result = await getActiveSpendingPlanUseCase();
    result.fold(_handleFailure, (plan) {
      activePlan.value = plan;
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
    isSaving.value = true;
    final result = await createSpendingPlanUseCase(request);
    final success = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (plan) {
        selectedPlan.value = plan;
        plans.insert(0, plan);
        AppHelperFunction.showSuccessSnackBar(
          'Tạo kế hoạch chi tiêu thành công',
        );
        return true;
      },
    );
    isSaving.value = false;
    return success;
  }

  Future<bool> updatePlan(int id, UpdateSpendingPlanRequest request) async {
    isSaving.value = true;
    final result = await updateSpendingPlanUseCase(id, request);
    final success = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (plan) {
        selectedPlan.value = plan;
        _replacePlan(plan);
        if (activePlan.value?.id == plan.id) {
          activePlan.value = plan;
        }
        AppHelperFunction.showSuccessSnackBar(
          'Cập nhật kế hoạch chi tiêu thành công',
        );
        return true;
      },
    );
    isSaving.value = false;
    return success;
  }

  Future<bool> deletePlan(int id) async {
    isSaving.value = true;
    final result = await deleteSpendingPlanUseCase(id);
    final success = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (_) {
        plans.removeWhere((item) => item.id == id);
        if (activePlan.value?.id == id) {
          activePlan.value = null;
        }
        if (selectedPlan.value?.id == id) {
          selectedPlan.value = null;
        }
        AppHelperFunction.showSuccessSnackBar('Đã xóa kế hoạch chi tiêu');
        return true;
      },
    );
    isSaving.value = false;
    return success;
  }

  Future<bool> activatePlan(int id) async {
    isSaving.value = true;
    final result = await activateSpendingPlanUseCase(id);
    final success = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (plan) {
        activePlan.value = plan;
        selectedPlan.value = plan;
        _replacePlan(plan);
        for (var i = 0; i < plans.length; i++) {
          final item = plans[i];
          if (item.id != plan.id && item.status == 'active') {
            plans[i] = SpendingPlanEntity(
              id: item.id,
              month: item.month,
              year: item.year,
              totalAmount: item.totalAmount,
              savingTargetAmount: item.savingTargetAmount,
              fixedExpenseTotal: item.fixedExpenseTotal,
              availableSpendingAmount: item.availableSpendingAmount,
              status: 'archived',
              riskLevel: item.riskLevel,
              fixedExpenses: item.fixedExpenses,
            );
          }
        }
        plans.refresh();
        AppHelperFunction.showSuccessSnackBar('Đã áp dụng kế hoạch');
        return true;
      },
    );
    isSaving.value = false;
    return success;
  }

  Future<bool> archivePlan(int id) async {
    isSaving.value = true;
    final result = await archiveSpendingPlanUseCase(id);
    final success = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (plan) {
        _replacePlan(plan);
        if (activePlan.value?.id == plan.id) {
          activePlan.value = null;
        }
        selectedPlan.value = plan;
        AppHelperFunction.showSuccessSnackBar('Đã lưu trữ kế hoạch');
        return true;
      },
    );
    isSaving.value = false;
    return success;
  }

  Future<bool> createFixedExpense(
    int planId,
    CreateFixedExpenseRequest request, {
    bool showSuccessMessage = true,
  }) async {
    isSaving.value = true;
    try {
      final remoteDs = Get.find<SpendingPlanRemoteDatasource>();
      final updatedModel = await remoteDs.createFixedExpense(planId, request);
      final updatedPlan = updatedModel.toEntity();
      selectedPlan.value = updatedPlan;
      _replacePlan(updatedPlan);
      if (activePlan.value?.id == planId) {
        activePlan.value = updatedPlan;
      }
      if (showSuccessMessage) {
        AppHelperFunction.showSuccessSnackBar(
          'Đã thêm chi phí cố định thành công',
        );
      }
      return true;
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateFixedExpense(
    int planId,
    int expenseId,
    Map<String, dynamic> data, {
    bool showSuccessMessage = true,
  }) async {
    isSaving.value = true;
    try {
      final remoteDs = Get.find<SpendingPlanRemoteDatasource>();
      final updatedModel = await remoteDs.updateFixedExpense(
        planId,
        expenseId,
        data,
      );
      final updatedPlan = updatedModel.toEntity();
      selectedPlan.value = updatedPlan;
      _replacePlan(updatedPlan);
      if (activePlan.value?.id == planId) {
        activePlan.value = updatedPlan;
      }
      if (showSuccessMessage) {
        AppHelperFunction.showSuccessSnackBar('Đã cập nhật chi phí cố định');
      }
      return true;
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> deleteFixedExpense(int planId, int expenseId) async {
    isSaving.value = true;
    try {
      final remoteDs = Get.find<SpendingPlanRemoteDatasource>();
      final updatedModel = await remoteDs.deleteFixedExpense(planId, expenseId);
      final updatedPlan = updatedModel.toEntity();
      selectedPlan.value = updatedPlan;
      _replacePlan(updatedPlan);
      if (activePlan.value?.id == planId) {
        activePlan.value = updatedPlan;
      }
      AppHelperFunction.showSuccessSnackBar('Đã xóa chi phí cố định');
      return true;
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> markFixedExpensePaid(
    int planId,
    int expenseId,
    bool isPaid,
  ) async {
    try {
      final remoteDs = Get.find<SpendingPlanRemoteDatasource>();
      final updatedModel = await remoteDs.markFixedExpensePaid(
        planId,
        expenseId,
        isPaid,
      );
      final updatedPlan = updatedModel.toEntity();
      selectedPlan.value = updatedPlan;
      _replacePlan(updatedPlan);
      if (activePlan.value?.id == planId) {
        activePlan.value = updatedPlan;
      }
      AppHelperFunction.showSuccessSnackBar(
        isPaid ? 'Đã đánh dấu đã thanh toán' : 'Đã đánh dấu chưa thanh toán',
      );
      return true;
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
      return false;
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
