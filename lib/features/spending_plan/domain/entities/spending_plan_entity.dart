import 'package:money_care/features/spending_plan/domain/entities/estimated_expense_entity.dart';

export 'estimated_expense_entity.dart';
export 'spending_plan_stats_entity.dart';

class SpendingPlanEntity {
  final int id;
  final double totalAmount;

  final double estimatedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<EstimatedExpenseEntity> estimatedExpenses;

  const SpendingPlanEntity({
    required this.id,
    required this.totalAmount,

    required this.estimatedExpenseTotal,
    required this.availableSpendingAmount,
    required this.status,
    required this.riskLevel,
    required this.estimatedExpenses,
  });

  bool get isActive => status == 'active';
  bool get isPaused => status == 'paused';
  int get month => DateTime.now().month;
  int get year => DateTime.now().year;

  SpendingPlanEntity copyWith({
    int? id,
    double? totalAmount,

    double? estimatedExpenseTotal,
    double? availableSpendingAmount,
    String? status,
    String? riskLevel,
    List<EstimatedExpenseEntity>? estimatedExpenses,
  }) {
    return SpendingPlanEntity(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,

      estimatedExpenseTotal:
          estimatedExpenseTotal ?? this.estimatedExpenseTotal,
      availableSpendingAmount:
          availableSpendingAmount ?? this.availableSpendingAmount,
      status: status ?? this.status,
      riskLevel: riskLevel ?? this.riskLevel,
      estimatedExpenses: estimatedExpenses ?? this.estimatedExpenses,
    );
  }
}
