class ScenarioGoalImpactModel {
  final int goalId;
  final String goalName;
  final String? currentPredictedCompletionDate;
  final String? newPredictedCompletionDate;
  final int? impactDays;
  final String impactText;

  const ScenarioGoalImpactModel({
    required this.goalId,
    required this.goalName,
    required this.currentPredictedCompletionDate,
    required this.newPredictedCompletionDate,
    required this.impactDays,
    required this.impactText,
  });

  factory ScenarioGoalImpactModel.fromJson(Map<String, dynamic> json) {
    return ScenarioGoalImpactModel(
      goalId: (json['goalId'] as num?)?.toInt() ?? 0,
      goalName: json['goalName']?.toString() ?? '',
      currentPredictedCompletionDate: json['currentPredictedCompletionDate']
          ?.toString(),
      newPredictedCompletionDate: json['newPredictedCompletionDate']
          ?.toString(),
      impactDays: (json['impactDays'] as num?)?.toInt(),
      impactText: json['impactText']?.toString() ?? '',
    );
  }
}

class ScenarioRecommendedActionModel {
  final String actionType;
  final String? categoryName;
  final double? amount;
  final String message;
  final String priority;

  const ScenarioRecommendedActionModel({
    required this.actionType,
    required this.categoryName,
    required this.amount,
    required this.message,
    required this.priority,
  });

  factory ScenarioRecommendedActionModel.fromJson(Map<String, dynamic> json) {
    return ScenarioRecommendedActionModel(
      actionType: json['actionType']?.toString() ?? '',
      categoryName: json['categoryName']?.toString(),
      amount: (json['amount'] as num?)?.toDouble(),
      message: json['message']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'medium',
    );
  }
}

class ScenarioSimulationModel {
  final String scenarioId;
  final String scenarioType;
  final String title;
  final String summary;
  final double monthlySaving;
  final double monthlyExpenseChange;
  final double monthlyIncomeChange;
  final double expectedSavingsAfter;
  final String budgetRiskBefore;
  final String budgetRiskAfter;
  final List<ScenarioGoalImpactModel> goalImpacts;
  final List<ScenarioRecommendedActionModel> recommendedActions;
  final double confidence;
  final List<String> reasonCodes;
  final Map<String, dynamic> supportingData;
  final String createdAt;

  const ScenarioSimulationModel({
    required this.scenarioId,
    required this.scenarioType,
    required this.title,
    required this.summary,
    required this.monthlySaving,
    required this.monthlyExpenseChange,
    required this.monthlyIncomeChange,
    required this.expectedSavingsAfter,
    required this.budgetRiskBefore,
    required this.budgetRiskAfter,
    required this.goalImpacts,
    required this.recommendedActions,
    required this.confidence,
    required this.reasonCodes,
    required this.supportingData,
    required this.createdAt,
  });

  factory ScenarioSimulationModel.fromJson(Map<String, dynamic> json) {
    return ScenarioSimulationModel(
      scenarioId: json['scenarioId']?.toString() ?? '',
      scenarioType: json['scenarioType']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      monthlySaving: (json['monthlySaving'] as num?)?.toDouble() ?? 0,
      monthlyExpenseChange:
          (json['monthlyExpenseChange'] as num?)?.toDouble() ?? 0,
      monthlyIncomeChange:
          (json['monthlyIncomeChange'] as num?)?.toDouble() ?? 0,
      expectedSavingsAfter:
          (json['expectedSavingsAfter'] as num?)?.toDouble() ?? 0,
      budgetRiskBefore: json['budgetRiskBefore']?.toString() ?? 'medium',
      budgetRiskAfter: json['budgetRiskAfter']?.toString() ?? 'medium',
      goalImpacts: _listOf(
        json['goalImpacts'],
      ).map(ScenarioGoalImpactModel.fromJson).toList(),
      recommendedActions: _listOf(
        json['recommendedActions'],
      ).map(ScenarioRecommendedActionModel.fromJson).toList(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      reasonCodes: (json['reasonCodes'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      supportingData: json['supportingData'] is Map<String, dynamic>
          ? json['supportingData'] as Map<String, dynamic>
          : const {},
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

List<Map<String, dynamic>> _listOf(dynamic value) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList();
}
