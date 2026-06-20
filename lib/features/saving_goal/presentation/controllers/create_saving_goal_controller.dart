import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';

class CreateSavingGoalController extends GetxController {
  late final SpendingPlanController spendingPlanController =
      Get.find<SpendingPlanController>();
  late final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();
  late final AppController appController = Get.find<AppController>();
  late final WalletController walletController = Get.find<WalletController>();

  CreateSavingGoalUseCase get _createUseCase =>
      Get.find<CreateSavingGoalUseCase>();
  UpdateSavingGoalUseCase get _updateUseCase =>
      Get.find<UpdateSavingGoalUseCase>();
  GetBudgetSuggestionUseCase get _getBudgetSuggestionUseCase =>
      Get.find<GetBudgetSuggestionUseCase>();

  Rxn<int> userId = Rxn<int>();
  RxBool isLoading = false.obs;
  RxBool isEditMode = false.obs;
  RxBool isCoupleMode = false.obs;
  Rxn<int> editingGoalId = Rxn<int>();

  final nameController = TextEditingController();
  final targetController = TextEditingController();
  final walletNameController = TextEditingController();

  Rxn<double> target = Rxn<double>();
  Rxn<DateTime> startDate = Rxn<DateTime>();
  Rxn<DateTime> endDate = Rxn<DateTime>();
  RxBool createNewWallet = true.obs;
  
  RxBool isBudgetEnabled = true.obs;
  RxString estimatedMonthlySavingsText = ''.obs;

  Rxn<BudgetSuggestionModel> budgetSuggestion = Rxn<BudgetSuggestionModel>();
  RxBool isLoadingSuggestion = false.obs;

  bool get hasActivePlan => spendingPlanController.activePlan.value != null;

  @override
  void onInit() {
    super.onInit();
    everAll([target, startDate, endDate, isBudgetEnabled], (_) {
      _updateEstimatedMonthlySavings();
    });

    // Debounce calls to suggest budget to avoid API overload during typing
    debounce(target, (_) => _loadBudgetSuggestion(), time: const Duration(milliseconds: 500));
    ever(startDate, (_) => _loadBudgetSuggestion());
    ever(endDate, (_) => _loadBudgetSuggestion());
    ever(userId, (_) => _loadBudgetSuggestion());
  }

  Future<void> _loadBudgetSuggestion() async {
    // Only load if user is logged in
    if (userId.value == null) return;
    isLoadingSuggestion.value = true;
    final result = await _getBudgetSuggestionUseCase(
      target: target.value,
      startDate: startDate.value,
      endDate: endDate.value,
    );
    result.fold(
      (failure) {
        isLoadingSuggestion.value = false;
        debugPrint('Lỗi tải gợi ý ngân sách: ${failure.message}');
      },
      (suggestion) {
        budgetSuggestion.value = suggestion;
        isLoadingSuggestion.value = false;
      },
    );
  }

  void _updateEstimatedMonthlySavings() {
    final t = target.value ?? 0;
    final start = startDate.value;
    final end = endDate.value;
    if (t <= 0 || start == null || end == null || end.isBefore(start) || !isBudgetEnabled.value) {
      estimatedMonthlySavingsText.value = '';
      return;
    }
    // Calculate months between start and end date
    int months = (end.year - start.year) * 12 + (end.month - start.month) + 1;
    if (months <= 0) {
      months = 1;
    }
    final monthlyAmount = t / months;
    estimatedMonthlySavingsText.value =
        'Dự kiến góp quỹ: ${AppHelperFunction.formatAmount(monthlyAmount)} / tháng vào Kế hoạch chi tiêu.';
  }

  @override
  void onClose() {
    nameController.dispose();
    targetController.dispose();
    super.onClose();
  }

  /// Gọi đồng bộ trước khi build screen để reset state cũ,
  /// tránh hiển thị dữ liệu từ lần navigate trước.
  void resetBeforeBuild() {
    isCoupleMode.value = false;
    isEditMode.value = false;
    isBudgetEnabled.value = true;
    estimatedMonthlySavingsText.value = '';
    budgetSuggestion.value = null;
    isLoadingSuggestion.value = false;
  }

  Future<void> initializeForm() async {
    await _initializeUserInfo();

    final arg = Get.arguments;
    if (arg is Map && arg['isCouple'] == true) {
      _resetForm();
      isCoupleMode.value = true;
      startDate.value = DateTime.now();
      if (arg['goal'] is CoupleSavingGoalEntity) {
        final goal = arg['goal'] as CoupleSavingGoalEntity;
        isEditMode.value = true;
        editingGoalId.value = goal.id;
        nameController.text = goal.name;
        target.value = goal.target;
        targetController.text = goal.target.toInt().toString();
        endDate.value = goal.endDate;
        createNewWallet.value = false;
        isBudgetEnabled.value = goal.isBudgetEnabled;
      }
    } else if (arg is SavingGoalEntity) {
      isCoupleMode.value = false;
      isEditMode.value = true;
      editingGoalId.value = arg.id;
      nameController.text = arg.name;
      target.value = arg.target;
      targetController.text = arg.target?.toInt().toString() ?? '';
      startDate.value = arg.startDate;
      endDate.value = arg.endDate;
      createNewWallet.value = false;
      isBudgetEnabled.value = arg.isBudgetEnabled;
    } else {
      _resetForm();
      startDate.value = DateTime.now();
    }
  }

  Future<void> _initializeUserInfo() async {
    final id = await appController.getCurrentUserId();
    if (id == null) return;
    userId.value = id;
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showStyledDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
    );
    if (picked != null) startDate.value = picked;
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showStyledDatePicker(
      context: context,
      initialDate:
          endDate.value ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: startDate.value ?? DateTime.now(),
    );
    if (picked != null) endDate.value = picked;
  }

  Future<bool> submit() async {
    if (nameController.text.isEmpty) {
      AppHelperFunction.showErrorSnackBar('Vui lòng nhập tên mục tiêu');
      return false;
    }
    if (startDate.value == null || endDate.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn thời gian');
      return false;
    }

    final rawTarget = AppHelperFunction.unformatCurrency(targetController.text);
    final finalTarget = double.tryParse(rawTarget) ?? 0;

    if (isCoupleMode.value) {
      if (Get.isRegistered<CoupleController>()) {
        isLoading.value = true;
        try {
          final coupleController = Get.find<CoupleController>();
          if (isEditMode.value) {
            await coupleController.updateSharedSavingGoal(
              id: editingGoalId.value!,
              name: nameController.text.trim(),
              target: finalTarget,
              endDate: endDate.value,
              isBudgetEnabled: isBudgetEnabled.value,
            );
          } else {
            await coupleController.createSharedSavingGoal(
              name: nameController.text.trim(),
              target: finalTarget,
              endDate: endDate.value,
              isBudgetEnabled: isBudgetEnabled.value,
            );
          }
          Get.back();
          return true;
        } catch (e) {
          AppHelperFunction.showErrorSnackBar('Lỗi lưu quỹ chung: $e');
          return false;
        } finally {
          isLoading.value = false;
        }
      } else {
        AppHelperFunction.showErrorSnackBar('Không tìm thấy CoupleController');
        return false;
      }
    }

    final dto = SavingGoalDto(
      id: isEditMode.value ? editingGoalId.value : null,
      name: nameController.text.trim(),
      userId: userId.value,
      target: finalTarget,
      savedAmount: 0,
      startDate: startDate.value,
      endDate: endDate.value,
      createNewWallet: isEditMode.value ? false : true,
      isBudgetEnabled: isBudgetEnabled.value,
    );

    isLoading.value = true;
    final result = isEditMode.value
        ? await _updateUseCase(dto)
        : await _createUseCase(dto);

    return result.fold(
      (failure) {
        isLoading.value = false;
        AppHelperFunction.showSnackBar(failure.message);
        return false;
      },
      (goal) {
        isLoading.value = false;
        savingGoalController.loadGoals(userId.value!);
        // Refresh spending plan if it's registered so user sees budget changes
        if (Get.isRegistered<SpendingPlanController>()) {
          Get.find<SpendingPlanController>().loadActivePlan();
        }
        Get.back();
        return true;
      },
    );
  }

  void _resetForm() {
    nameController.clear();
    targetController.clear();
    target.value = null;
    startDate.value = DateTime.now();
    endDate.value = null;
    createNewWallet.value = true;
    isEditMode.value = false;
    isCoupleMode.value = false;
    isBudgetEnabled.value = true;
    estimatedMonthlySavingsText.value = '';
    budgetSuggestion.value = null;
    isLoadingSuggestion.value = false;
  }
}
