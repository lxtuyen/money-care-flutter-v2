import 'package:money_care/features/spending_plan/domain/entities/estimated_expense_entity.dart';

class SpendingPlanStatsEntity {
  final int planId;
  final String planName;
  final double totalAmount;
  final double availableSpendingAmount;
  final double spentAmount;
  final double remainingAmount;
  final int daysLeft;
  final double projectedEndBalance;
  final List<EstimatedExpenseEntity> estimatedExpenses;

  const SpendingPlanStatsEntity({
    required this.planId,
    required this.planName,
    required this.totalAmount,
    required this.availableSpendingAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.daysLeft,
    required this.projectedEndBalance,
    required this.estimatedExpenses,
  });
}
