import 'package:money_care/features/spending_plan/data/models/model_parse_utils.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'estimated_expense_model.dart';

export 'estimated_expense_model.dart';
export 'spending_plan_stats_model.dart';

class SpendingPlanModel {
  final int id;
  final double totalAmount;
  final double estimatedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<EstimatedExpenseModel> estimatedExpenses;

  const SpendingPlanModel({
    required this.id,
    required this.totalAmount,
    required this.estimatedExpenseTotal,
    required this.availableSpendingAmount,
    required this.status,
    required this.riskLevel,
    required this.estimatedExpenses,
  });

  factory SpendingPlanModel.fromJson(Map<String, dynamic> json) {
    final rawEstimatedExpenses =
        json['estimatedExpenses'] ?? json['fixedExpenses'];
    return SpendingPlanModel(
      id: asInt(json['id']),
      totalAmount: asDouble(json['totalAmount']),
      estimatedExpenseTotal: asDouble(
        json['estimatedExpenseTotal'] ?? json['fixedExpenseTotal'],
      ),
      availableSpendingAmount: asDouble(json['availableSpendingAmount']),
      status: json['status']?.toString() ?? 'draft',
      riskLevel: json['riskLevel']?.toString() ?? 'warning',
      estimatedExpenses: rawEstimatedExpenses is List
          ? rawEstimatedExpenses
                .whereType<Map<String, dynamic>>()
                .map(EstimatedExpenseModel.fromJson)
                .toList()
          : const [],
    );
  }

  SpendingPlanEntity toEntity() {
    return SpendingPlanEntity(
      id: id,
      totalAmount: totalAmount,
      estimatedExpenseTotal: estimatedExpenseTotal,
      availableSpendingAmount: availableSpendingAmount,
      status: status,
      riskLevel: riskLevel,
      estimatedExpenses: estimatedExpenses
          .map((expense) => expense.toEntity())
          .toList(),
    );
  }
}


