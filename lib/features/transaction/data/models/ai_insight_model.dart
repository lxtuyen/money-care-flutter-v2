import 'package:money_care/features/transaction/domain/entities/ai_insight_entity.dart';

class AiInsightModel extends AiInsightEntity {
  AiInsightModel({
    required super.period,
    required super.generatedAt,
    required super.incomeTotal,
    required super.expenseTotal,
    required super.netBalance,
    required super.dailyAverage,
    required super.topCategories,
    required super.alerts,
    required super.comparisonPrevMonth,
  });

  factory AiInsightModel.fromJson(Map<String, dynamic> json) {
    return AiInsightModel(
      period: json['period'],
      generatedAt: json['generatedAt'],
      incomeTotal: (json['incomeTotal'] as num).toDouble(),
      expenseTotal: (json['expenseTotal'] as num).toDouble(),
      netBalance: (json['netBalance'] as num).toDouble(),
      dailyAverage: (json['dailyAverage'] as num).toDouble(),
      topCategories: (json['topCategories'] as List)
          .map((e) => AiInsightCategorySummaryModel.fromJson(e))
          .toList(),
      alerts: List<String>.from(json['alerts']),
      comparisonPrevMonth: AiInsightComparisonModel.fromJson(json['comparisonPrevMonth']),
    );
  }
}

class AiInsightCategorySummaryModel extends AiInsightCategorySummary {
  AiInsightCategorySummaryModel({
    required super.name,
    required super.amount,
    required super.changePct,
    required super.percentageOfExpenses,
    super.icon,
  });

  factory AiInsightCategorySummaryModel.fromJson(Map<String, dynamic> json) {
    return AiInsightCategorySummaryModel(
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      changePct: (json['changePct'] as num).toDouble(),
      percentageOfExpenses: json['percentageOfExpenses'],
      icon: json['icon'],
    );
  }
}

class AiInsightComparisonModel extends AiInsightComparison {
  AiInsightComparisonModel({
    required super.incomeChangePct,
    required super.expenseChangePct,
    required super.netBalanceChangePct,
  });

  factory AiInsightComparisonModel.fromJson(Map<String, dynamic> json) {
    return AiInsightComparisonModel(
      incomeChangePct: (json['incomeChangePct'] as num).toDouble(),
      expenseChangePct: (json['expenseChangePct'] as num).toDouble(),
      netBalanceChangePct: (json['netBalanceChangePct'] as num).toDouble(),
    );
  }
}
