class GoalRecommendedActionModel {
  final String actionType;
  final double? amount;
  final String? categoryName;
  final String? suggestedDeadline;
  final String message;
  final int? impactDays;

  const GoalRecommendedActionModel({
    required this.actionType,
    this.amount,
    this.categoryName,
    this.suggestedDeadline,
    required this.message,
    this.impactDays,
  });

  factory GoalRecommendedActionModel.fromJson(Map<String, dynamic> json) {
    return GoalRecommendedActionModel(
      actionType: json['actionType']?.toString() ?? 'keep_current_plan',
      amount: _parseDoubleNullable(json['amount']),
      categoryName: json['categoryName']?.toString(),
      suggestedDeadline: json['suggestedDeadline']?.toString(),
      message: json['message']?.toString() ?? '',
      impactDays: _parseIntNullable(json['impactDays']),
    );
  }
}

class GoalAchievementPredictionModel {
  final int goalId;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final double remainingAmount;
  final String? startDate;
  final String? deadline;
  final String? predictedCompletionDate;
  final int? daysRemainingToDeadline;
  final int? predictedDaysToComplete;
  final int? daysDifference;
  final String status;
  final String riskLevel;
  final double progressPct;
  final double currentMonthlySavingRate;
  final double projectedMonthlySavingRate;
  final double requiredMonthlySavingRate;
  final double requiredWeeklySavingRate;
  final double requiredDailySavingRate;
  final double shortfallAmount;
  final double surplusAmount;
  final double confidence;
  final List<String> reasonCodes;
  final List<GoalRecommendedActionModel> recommendedActions;
  final Map<String, dynamic> supportingData;

  const GoalAchievementPredictionModel({
    required this.goalId,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.remainingAmount,
    this.startDate,
    this.deadline,
    this.predictedCompletionDate,
    this.daysRemainingToDeadline,
    this.predictedDaysToComplete,
    this.daysDifference,
    required this.status,
    required this.riskLevel,
    required this.progressPct,
    required this.currentMonthlySavingRate,
    required this.projectedMonthlySavingRate,
    required this.requiredMonthlySavingRate,
    required this.requiredWeeklySavingRate,
    required this.requiredDailySavingRate,
    required this.shortfallAmount,
    required this.surplusAmount,
    required this.confidence,
    required this.reasonCodes,
    required this.recommendedActions,
    required this.supportingData,
  });

  factory GoalAchievementPredictionModel.fromJson(Map<String, dynamic> json) {
    return GoalAchievementPredictionModel(
      goalId: _parseInt(json['goalId']),
      name: json['name']?.toString() ?? '',
      targetAmount: _parseDouble(json['targetAmount']),
      savedAmount: _parseDouble(json['savedAmount']),
      remainingAmount: _parseDouble(json['remainingAmount']),
      startDate: json['startDate']?.toString(),
      deadline: json['deadline']?.toString(),
      predictedCompletionDate: json['predictedCompletionDate']?.toString(),
      daysRemainingToDeadline: _parseIntNullable(
        json['daysRemainingToDeadline'],
      ),
      predictedDaysToComplete: _parseIntNullable(
        json['predictedDaysToComplete'],
      ),
      daysDifference: _parseIntNullable(json['daysDifference']),
      status: json['status']?.toString() ?? 'tracking',
      riskLevel: json['riskLevel']?.toString() ?? 'low',
      progressPct: _parseDouble(json['progressPct']),
      currentMonthlySavingRate: _parseDouble(json['currentMonthlySavingRate']),
      projectedMonthlySavingRate: _parseDouble(
        json['projectedMonthlySavingRate'],
      ),
      requiredMonthlySavingRate: _parseDouble(
        json['requiredMonthlySavingRate'],
      ),
      requiredWeeklySavingRate: _parseDouble(json['requiredWeeklySavingRate']),
      requiredDailySavingRate: _parseDouble(json['requiredDailySavingRate']),
      shortfallAmount: _parseDouble(json['shortfallAmount']),
      surplusAmount: _parseDouble(json['surplusAmount']),
      confidence: _parseDouble(json['confidence']),
      reasonCodes:
          (json['reasonCodes'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          <String>[],
      recommendedActions:
          (json['recommendedActions'] as List?)
              ?.map(
                (item) => GoalRecommendedActionModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          <GoalRecommendedActionModel>[],
      supportingData: json['supportingData'] is Map<String, dynamic>
          ? json['supportingData'] as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }
}

class GoalAchievementPredictionSummaryModel {
  final int totalGoals;
  final int onTrackGoals;
  final int atRiskGoals;
  final int offTrackGoals;
  final GoalAchievementPredictionModel? nearestGoal;
  final GoalAchievementPredictionModel? highestRiskGoal;
  final List<GoalAchievementPredictionModel> predictions;

  const GoalAchievementPredictionSummaryModel({
    required this.totalGoals,
    required this.onTrackGoals,
    required this.atRiskGoals,
    required this.offTrackGoals,
    this.nearestGoal,
    this.highestRiskGoal,
    required this.predictions,
  });

  factory GoalAchievementPredictionSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GoalAchievementPredictionSummaryModel(
      totalGoals: _parseInt(json['totalGoals']),
      onTrackGoals: _parseInt(json['onTrackGoals']),
      atRiskGoals: _parseInt(json['atRiskGoals']),
      offTrackGoals: _parseInt(json['offTrackGoals']),
      nearestGoal: json['nearestGoal'] is Map<String, dynamic>
          ? GoalAchievementPredictionModel.fromJson(
              json['nearestGoal'] as Map<String, dynamic>,
            )
          : null,
      highestRiskGoal: json['highestRiskGoal'] is Map<String, dynamic>
          ? GoalAchievementPredictionModel.fromJson(
              json['highestRiskGoal'] as Map<String, dynamic>,
            )
          : null,
      predictions:
          (json['predictions'] as List?)
              ?.map(
                (item) => GoalAchievementPredictionModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          <GoalAchievementPredictionModel>[],
    );
  }
}

double _parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _parseDoubleNullable(dynamic value) {
  if (value == null) return null;
  return _parseDouble(value);
}

int _parseInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  return _parseInt(value);
}
