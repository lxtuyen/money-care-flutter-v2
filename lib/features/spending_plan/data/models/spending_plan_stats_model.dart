import 'package:money_care/features/spending_plan/data/models/model_parse_utils.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'estimated_expense_model.dart';

class SpendingPlanStatsModel {
  final int planId;
  final String planName;
  final double totalAmount;
  final double availableSpendingAmount;
  final double spentAmount;
  final double remainingAmount;
  final int daysLeft;
  final double projectedEndBalance;
  final List<EstimatedExpenseModel> estimatedExpenses;

  const SpendingPlanStatsModel({
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

  factory SpendingPlanStatsModel.fromJson(Map<String, dynamic> json) {
    final rawEstimatedExpenses =
        json['estimatedExpenses'] ?? json['fixedExpenses'];
    return SpendingPlanStatsModel(
      planId: asInt(json['planId']),
      planName: json['planName']?.toString() ?? '',
      totalAmount: asDouble(json['totalAmount']),
      availableSpendingAmount: asDouble(json['availableSpendingAmount']),
      spentAmount: asDouble(json['spentAmount']),
      remainingAmount: asDouble(json['remainingAmount']),
      daysLeft: asInt(json['daysLeft']),
      projectedEndBalance: asDouble(json['projectedEndBalance']),
      estimatedExpenses: rawEstimatedExpenses is List
          ? rawEstimatedExpenses
                .map((e) => Map<String, dynamic>.from(e as Map))
                .map(EstimatedExpenseModel.fromJson)
                .toList()
          : const [],
    );
  }

  SpendingPlanStatsEntity toEntity() {
    return SpendingPlanStatsEntity(
      planId: planId,
      planName: planName,
      totalAmount: totalAmount,
      availableSpendingAmount: availableSpendingAmount,
      spentAmount: spentAmount,
      remainingAmount: remainingAmount,
      daysLeft: daysLeft,
      projectedEndBalance: projectedEndBalance,
      estimatedExpenses: estimatedExpenses.map((e) => e.toEntity()).toList(),
    );
  }
}


