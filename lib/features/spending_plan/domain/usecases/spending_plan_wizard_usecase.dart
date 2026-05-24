import 'package:money_care/features/spending_plan/domain/entities/entities.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';

class SpendingPlanWizardUseCase {
  int daysInMonth({DateTime? date}) {
    final now = date ?? DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  double parseMoney(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0;
  }

  double monthlyAmountFor(EstimatedExpenseEntity expense, {DateTime? date}) {
    final days = daysInMonth(date: date);
    switch (expense.frequencyType) {
      case 'daily':
        return expense.amount * expense.frequencyValue * days;
      case 'weekly':
        return expense.amount * expense.frequencyValue * (days / 7);
      case 'monthly':
      default:
        return expense.amount * expense.frequencyValue;
    }
  }

  double estimatedExpenseTotal(List<EstimatedExpenseEntity> expenses) {
    return expenses.fold(0, (total, expense) {
      return total + monthlyAmountFor(expense);
    });
  }

  double remainingAmount({
    required double income,
    required List<EstimatedExpenseEntity> expenses,
  }) {
    return income - estimatedExpenseTotal(expenses);
  }

  double dailyFlexibleAmount(List<EstimatedExpenseEntity> expenses) {
    final total = estimatedExpenseTotal(expenses);
    if (total <= 0) return 0;
    return total / daysInMonth();
  }

  double estimatedExpenseRatio({
    required double income,
    required List<EstimatedExpenseEntity> expenses,
  }) {
    if (income <= 0) return 0;
    return (estimatedExpenseTotal(expenses) / income).clamp(0.0, 1.0);
  }

  double flexibleExpenseRatio({
    required double income,
    required List<EstimatedExpenseEntity> expenses,
  }) {
    final remaining = remainingAmount(income: income, expenses: expenses);
    if (income <= 0 || remaining <= 0) return 0;
    return (remaining / income).clamp(0.0, 1.0);
  }

  bool canSave({
    required double income,
    required List<EstimatedExpenseEntity> expenses,
  }) {
    return income > 0 &&
        expenses.isNotEmpty &&
        remainingAmount(income: income, expenses: expenses) >= 0;
  }

  EstimatedExpenseEntity buildDraftExpense({
    required int id,
    required CreateEstimatedExpenseRequest request,
  }) {
    return EstimatedExpenseEntity(
      id: id,
      category: request.category,
      categoryId: request.categoryId,
      subCategory: request.subCategory,
      subCategoryId: request.subCategoryId,
      amount: request.amount,
      frequencyType: request.frequencyType ?? 'monthly',
      frequencyValue: request.frequencyValue ?? 1,
    );
  }

  List<CreateEstimatedExpenseRequest> buildExpenseRequests(
    List<EstimatedExpenseEntity> expenses,
  ) {
    return expenses.where((expense) => expense.amount > 0).map((expense) {
      return CreateEstimatedExpenseRequest(
        category: expense.category ?? '',
        categoryId: expense.categoryId ?? 0,
        subCategory: expense.subCategory,
        subCategoryId: expense.subCategoryId,
        amount: expense.amount,
        monthlyLimit: monthlyAmountFor(expense),
        dailyLimit: expense.frequencyType == 'daily'
            ? expense.amount * expense.frequencyValue
            : null,
        frequencyType: expense.frequencyType,
        frequencyValue: expense.frequencyValue,
      );
    }).toList();
  }

  CreateSpendingPlanRequest buildCreateRequest({
    required double income,
    required List<EstimatedExpenseEntity> expenses,
  }) {
    return CreateSpendingPlanRequest(
      totalAmount: income,
      estimatedExpenses: buildExpenseRequests(expenses),
    );
  }

  UpdateSpendingPlanRequest buildUpdateRequest({
    required double income,
    required List<EstimatedExpenseEntity> expenses,
  }) {
    return UpdateSpendingPlanRequest(
      totalAmount: income,
      estimatedExpenses: buildExpenseRequests(expenses),
    );
  }
}
