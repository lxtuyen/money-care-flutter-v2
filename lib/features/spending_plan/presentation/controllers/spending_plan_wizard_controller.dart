import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/spending_plan/domain/usecases/usecases.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class SpendingPlanWizardController extends GetxController {
  final SpendingPlanWizardUseCase wizardUseCase;

  SpendingPlanWizardController({SpendingPlanWizardUseCase? wizardUseCase})
    : wizardUseCase = wizardUseCase ?? SpendingPlanWizardUseCase();

  final monthlyIncome = 0.0.obs;
  final estimatedExpenses = <EstimatedExpenseEntity>[].obs;
  final currentStep = 0.obs;
  var showWelcomeStep = false;

  UserCategoryController get _categoryController =>
      Get.find<UserCategoryController>();

  double get estimatedExpenseTotal =>
      wizardUseCase.estimatedExpenseTotal(estimatedExpenses);

  double get remainingAmount => wizardUseCase.remainingAmount(
    income: monthlyIncome.value,
    expenses: estimatedExpenses,
  );

  double get estimatedExpenseRatio => wizardUseCase.estimatedExpenseRatio(
    income: monthlyIncome.value,
    expenses: estimatedExpenses,
  );

  double get flexibleExpenseRatio => wizardUseCase.flexibleExpenseRatio(
    income: monthlyIncome.value,
    expenses: estimatedExpenses,
  );

  bool get canSave => wizardUseCase.canSave(
    income: monthlyIncome.value,
    expenses: estimatedExpenses,
  ) && estimatedExpenses.every((e) => e.amount > 0);

  void initialize({
    double? income,
    List<EstimatedExpenseEntity>? expenses,
    bool showWelcomeStep = false,
  }) {
    this.showWelcomeStep = showWelcomeStep;
    currentStep.value = 0;
    monthlyIncome.value = income ?? 0.0;
    estimatedExpenses.assignAll(expenses ?? []);
  }

  int get incomeStepIndex => showWelcomeStep ? 1 : 0;

  int get expensesStepIndex => showWelcomeStep ? 2 : 1;

  int get maxStepIndex => showWelcomeStep ? 2 : 1;

  bool get shouldShowHeader => !showWelcomeStep || currentStep.value > 0;

  String get currentTitle => currentStep.value == incomeStepIndex
      ? 'Thu nhập hàng tháng'
      : 'Khoản chi dự kiến';

  bool goToNextStep() {
    if (currentStep.value >= maxStepIndex) return false;
    currentStep.value++;
    return true;
  }

  bool goToPreviousStep() {
    if (currentStep.value <= 0) return false;
    currentStep.value--;
    return true;
  }

  WizardBackAction handleBackTap() {
    if (currentStep.value == incomeStepIndex) {
      if (showWelcomeStep) {
        return goToPreviousStep()
            ? WizardBackAction.changedStep
            : WizardBackAction.none;
      }
      return WizardBackAction.close;
    }

    if (currentStep.value == expensesStepIndex) {
      return goToPreviousStep()
          ? WizardBackAction.changedStep
          : WizardBackAction.none;
    }

    return WizardBackAction.none;
  }

  void updateIncomeFromText(String value) {
    monthlyIncome.value = wizardUseCase.parseMoney(value);
  }

  double monthlyAmountFor(EstimatedExpenseEntity expense) {
    return wizardUseCase.monthlyAmountFor(expense);
  }

  Future<void> loadCategoriesIfNeeded() async {
    final userId = Get.find<AppController>().userId.value;
    if (userId != null && _categoryController.categories.isEmpty) {
      await _categoryController.loadCategories(userId);
    }
  }

  void addExpense(EstimatedExpenseEntity expense) {
    estimatedExpenses.add(expense.copyWith(id: estimatedExpenses.length));
  }

  void updateExpense(int index, EstimatedExpenseEntity expense) {
    if (index < 0 || index >= estimatedExpenses.length) return;
    estimatedExpenses[index] = expense.copyWith(id: index);
  }

  void removeExpense(int index) {
    if (index < 0 || index >= estimatedExpenses.length) return;
    estimatedExpenses.removeAt(index);
  }

  void saveDraftExpense({
    int? index,
    required CreateEstimatedExpenseRequest request,
  }) {
    final draft = wizardUseCase.buildDraftExpense(
      id: index ?? estimatedExpenses.length,
      request: request,
    );
    if (index == null) {
      addExpense(draft);
    } else {
      updateExpense(index, draft);
    }
  }

  /// Thêm khoản chi với amount = 0 ngay vào list (chưa nhập tiền).
  /// Trả về index của item vừa thêm.
  int addEmptyExpense({
    required String category,
    required int? categoryId,
  }) {
    final id = estimatedExpenses.length;
    estimatedExpenses.add(EstimatedExpenseEntity(
      id: id,
      category: category,
      categoryId: categoryId,
      amount: 0,
      frequencyType: 'monthly',
      frequencyValue: 1,
    ));
    return estimatedExpenses.length - 1;
  }

  bool get hasUnfilledExpenses => estimatedExpenses.any((e) => e.amount <= 0);
  bool quickUpdateExpenseAmount(int index, double newAmount) {
    if (index < 0 || index >= estimatedExpenses.length) return false;
    if (newAmount <= 0) return false;
    final existing = estimatedExpenses[index];
    estimatedExpenses[index] = existing.copyWith(amount: newAmount);
    return true;
  }

  CreateSpendingPlanRequest buildCreateRequest() {
    return wizardUseCase.buildCreateRequest(
      income: monthlyIncome.value,
      expenses: estimatedExpenses,
    );
  }

  UpdateSpendingPlanRequest buildUpdateRequest() {
    return wizardUseCase.buildUpdateRequest(
      income: monthlyIncome.value,
      expenses: estimatedExpenses,
    );
  }
}

enum WizardBackAction { none, changedStep, close }
