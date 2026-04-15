import 'package:flutter/material.dart';

class AiInsightEntity {
  final String period;
  final String generatedAt;
  final double incomeTotal;
  final double expenseTotal;
  final double netBalance;
  final double dailyAverage;
  final List<AiInsightCategorySummary> topCategories;
  final List<String> alerts;
  final AiInsightComparison comparisonPrevMonth;

  AiInsightEntity({
    required this.period,
    required this.generatedAt,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.netBalance,
    required this.dailyAverage,
    required this.topCategories,
    required this.alerts,
    required this.comparisonPrevMonth,
  });
}

class AiInsightCategorySummary {
  final String name;
  final double amount;
  final double changePct;
  final int percentageOfExpenses;
  final String? icon;

  AiInsightCategorySummary({
    required this.name,
    required this.amount,
    required this.changePct,
    required this.percentageOfExpenses,
    this.icon,
  });
}

class AiInsightComparison {
  final double incomeChangePct;
  final double expenseChangePct;
  final double netBalanceChangePct;

  AiInsightComparison({
    required this.incomeChangePct,
    required this.expenseChangePct,
    required this.netBalanceChangePct,
  });
}
