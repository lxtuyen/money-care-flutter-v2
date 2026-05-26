import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/spending_plan/domain/usecases/usecases.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/domain/usecases/category_preference_usecases.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class SpendingPlanWizardController extends GetxController {
  final SpendingPlanWizardUseCase wizardUseCase;

  SpendingPlanWizardController({SpendingPlanWizardUseCase? wizardUseCase})
    : wizardUseCase = wizardUseCase ?? SpendingPlanWizardUseCase();

  final monthlyIncome = 0.0.obs;
  final estimatedExpenses = <EstimatedExpenseEntity>[].obs;
  final selectedEssentialCategoryIds = <int>{}.obs;
  final currentStep = 0.obs;
  var showWelcomeStep = false;

  UserCategoryController get _categoryController =>
      Get.find<UserCategoryController>();

  GetEssentialExpenseCategoryIdsUseCase? get _getEssentialCategoriesUseCase =>
      Get.isRegistered<GetEssentialExpenseCategoryIdsUseCase>()
      ? Get.find<GetEssentialExpenseCategoryIdsUseCase>()
      : null;

  SaveEssentialExpenseCategoryIdsUseCase? get _saveEssentialCategoriesUseCase =>
      Get.isRegistered<SaveEssentialExpenseCategoryIdsUseCase>()
      ? Get.find<SaveEssentialExpenseCategoryIdsUseCase>()
      : null;

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

  bool get canSave =>
      wizardUseCase.canSave(
        income: monthlyIncome.value,
        expenses: estimatedExpenses,
      ) &&
      estimatedExpenses.every((e) => e.amount > 0);

  void initialize({
    double? income,
    List<EstimatedExpenseEntity>? expenses,
    bool showWelcomeStep = false,
  }) {
    this.showWelcomeStep = showWelcomeStep;
    currentStep.value = 0;
    monthlyIncome.value = income ?? 0.0;
    estimatedExpenses.assignAll(expenses ?? []);
    selectedEssentialCategoryIds.assignAll(
      estimatedExpenses
          .map((expense) => expense.categoryId)
          .whereType<int>()
          .toSet(),
    );
  }

  int get incomeStepIndex => showWelcomeStep ? 1 : 0;

  int get categoryStepIndex => showWelcomeStep ? 2 : 1;

  int get expensesStepIndex => showWelcomeStep ? 3 : 2;

  int get maxStepIndex => showWelcomeStep ? 3 : 2;

  bool get shouldShowHeader => !showWelcomeStep || currentStep.value > 0;

  String get currentTitle {
    if (currentStep.value == incomeStepIndex) {
      return 'Thu nhập hằng tháng';
    }
    if (currentStep.value == categoryStepIndex) {
      return 'Danh mục thiết yếu';
    }
    return 'Ngân sách dự kiến';
  }

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

    if (currentStep.value == categoryStepIndex ||
        currentStep.value == expensesStepIndex) {
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
    await loadEssentialCategoryPreferencesIfNeeded();
  }

  Future<void> loadEssentialCategoryPreferencesIfNeeded() async {
    if (selectedEssentialCategoryIds.isNotEmpty) return;
    final useCase = _getEssentialCategoriesUseCase;
    if (useCase == null) return;

    try {
      final ids = await useCase();
      selectedEssentialCategoryIds.assignAll(ids);
      prepareExpensesFromSelectedCategories();
    } catch (_) {}
  }

  List<CategoryEntity> get expenseCategories => _categoryController.categories
      .where((category) => category.type == 'expense')
      .toList();

  List<CategoryEntity> get selectedExpenseCategories => expenseCategories
      .where(
        (category) =>
            category.id != null &&
            selectedEssentialCategoryIds.contains(category.id),
      )
      .toList();

  bool get hasSelectedEssentialCategories =>
      selectedEssentialCategoryIds.isNotEmpty;

  bool isEssentialCategorySelected(CategoryEntity category) {
    final id = category.id;
    return id != null && selectedEssentialCategoryIds.contains(id);
  }

  void toggleEssentialCategory(CategoryEntity category) {
    final id = category.id;
    if (id == null) return;

    final nextIds = selectedEssentialCategoryIds.toSet();
    if (nextIds.contains(id)) {
      nextIds.remove(id);
    } else {
      nextIds.add(id);
    }
    selectedEssentialCategoryIds.assignAll(nextIds);
    selectedEssentialCategoryIds.refresh();
    prepareExpensesFromSelectedCategories();
  }

  void prepareExpensesFromSelectedCategories() {
    final selectedIds = selectedEssentialCategoryIds.toSet();
    estimatedExpenses.removeWhere(
      (expense) =>
          expense.categoryId != null &&
          !selectedIds.contains(expense.categoryId),
    );

    for (final category in selectedExpenseCategories) {
      final categoryId = category.id;
      if (categoryId == null) continue;
      final exists = estimatedExpenses.any(
        (expense) => expense.categoryId == categoryId,
      );
      if (exists) continue;
      addEmptyExpense(category: category.name, categoryId: categoryId);
    }
  }

  Future<void> saveEssentialCategoryPreferences() async {
    final useCase = _saveEssentialCategoriesUseCase;
    if (useCase == null) return;
    await useCase(selectedEssentialCategoryIds.toSet());
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

  int addEmptyExpense({required String category, required int? categoryId}) {
    final id = estimatedExpenses.length;
    estimatedExpenses.add(
      EstimatedExpenseEntity(
        id: id,
        category: category,
        categoryId: categoryId,
        amount: 0,
        frequencyType: 'monthly',
        frequencyValue: 1,
      ),
    );
    return estimatedExpenses.length - 1;
  }

  bool get hasUnfilledExpenses => estimatedExpenses.any((e) => e.amount <= 0);

  void updateExpenseAmountByCategoryId(int categoryId, double newAmount) {
    final index = estimatedExpenses.indexWhere(
      (expense) => expense.categoryId == categoryId,
    );
    if (index < 0) return;
    final existing = estimatedExpenses[index];
    estimatedExpenses[index] = existing.copyWith(amount: newAmount);
  }

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
