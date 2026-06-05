class AnomalyModel {
  final int transactionId;
  final double amount;
  final String date;
  final String categoryName;
  final String reason;

  const AnomalyModel({
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.categoryName,
    required this.reason,
  });

  factory AnomalyModel.fromJson(Map<String, dynamic> json) {
    return AnomalyModel(
      transactionId: json['transactionId'] as int? ?? 0,
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      date: json['date']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class BudgetRiskItemModel {
  final String categoryName;
  final double limitAmount;
  final double spentAmount;
  final double riskScore;
  final String status;

  const BudgetRiskItemModel({
    required this.categoryName,
    required this.limitAmount,
    required this.spentAmount,
    required this.riskScore,
    required this.status,
  });

  factory BudgetRiskItemModel.fromJson(Map<String, dynamic> json) {
    return BudgetRiskItemModel(
      categoryName: json['categoryName']?.toString() ?? '',
      limitAmount: (json['limitAmount'] as num? ?? 0.0).toDouble(),
      spentAmount: (json['spentAmount'] as num? ?? 0.0).toDouble(),
      riskScore: (json['riskScore'] as num? ?? 0.0).toDouble(),
      status: json['status']?.toString() ?? 'normal',
    );
  }
}

class BudgetRiskModel {
  final String riskLevel;
  final String message;
  final List<BudgetRiskItemModel> items;

  const BudgetRiskModel({
    required this.riskLevel,
    required this.message,
    required this.items,
  });

  factory BudgetRiskModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List?;
    final itemsList = list != null
        ? list
              .map(
                (e) => BudgetRiskItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <BudgetRiskItemModel>[];
    return BudgetRiskModel(
      riskLevel: json['riskLevel']?.toString() ?? 'low',
      message: json['message']?.toString() ?? '',
      items: itemsList,
    );
  }
}

class SavingGoalProjectionModel {
  final int goalId;
  final String name;
  final double monthsRemaining;
  final double monthsDiff;
  final bool isOnTrack;
  final String statusText;

  const SavingGoalProjectionModel({
    required this.goalId,
    required this.name,
    required this.monthsRemaining,
    required this.monthsDiff,
    required this.isOnTrack,
    required this.statusText,
  });

  factory SavingGoalProjectionModel.fromJson(Map<String, dynamic> json) {
    return SavingGoalProjectionModel(
      goalId: json['goalId'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      monthsRemaining: (json['monthsRemaining'] as num? ?? 0.0).toDouble(),
      monthsDiff: (json['monthsDiff'] as num? ?? 0.0).toDouble(),
      isOnTrack: json['isOnTrack'] as bool? ?? true,
      statusText: json['statusText']?.toString() ?? '',
    );
  }
}

class InsightModel {
  final String title;
  final String message;
  final String severity; // 'info', 'warning', 'success'
  final String evidence;

  const InsightModel({
    required this.title,
    required this.message,
    required this.severity,
    required this.evidence,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'info',
      evidence: json['evidence']?.toString() ?? '',
    );
  }
}

class ForecastPointModel {
  final String date;
  final double predictedAmount;

  const ForecastPointModel({required this.date, required this.predictedAmount});

  factory ForecastPointModel.fromJson(Map<String, dynamic> json) {
    return ForecastPointModel(
      date: json['date']?.toString() ?? '',
      predictedAmount: (json['predictedAmount'] as num? ?? 0.0).toDouble(),
    );
  }
}

class CategoryForecastModel {
  final String categoryName;
  final double predictedAmount;
  final double confidence;
  final String trend;
  final int dataPoints;

  const CategoryForecastModel({
    required this.categoryName,
    required this.predictedAmount,
    required this.confidence,
    required this.trend,
    required this.dataPoints,
  });

  factory CategoryForecastModel.fromJson(Map<String, dynamic> json) {
    return CategoryForecastModel(
      categoryName: json['categoryName']?.toString() ?? '',
      predictedAmount: (json['predictedAmount'] as num? ?? 0.0).toDouble(),
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      trend: json['trend']?.toString() ?? 'stable',
      dataPoints: json['dataPoints'] as int? ?? 0,
    );
  }
}

class ForecastingModel {
  final String method;
  final int horizonDays;
  final double totalForecast;
  final double confidence;
  final List<ForecastPointModel> dailyPoints;
  final List<CategoryForecastModel> categoryForecasts;
  final String modelNotes;

  const ForecastingModel({
    required this.method,
    required this.horizonDays,
    required this.totalForecast,
    required this.confidence,
    required this.dailyPoints,
    required this.categoryForecasts,
    required this.modelNotes,
  });

  factory ForecastingModel.fromJson(Map<String, dynamic> json) {
    return ForecastingModel(
      method: json['method']?.toString() ?? '',
      horizonDays: json['horizonDays'] as int? ?? 30,
      totalForecast: (json['totalForecast'] as num? ?? 0.0).toDouble(),
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      dailyPoints:
          (json['dailyPoints'] as List?)
              ?.map(
                (e) => ForecastPointModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <ForecastPointModel>[],
      categoryForecasts:
          (json['categoryForecasts'] as List?)
              ?.map(
                (e) =>
                    CategoryForecastModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <CategoryForecastModel>[],
      modelNotes: json['modelNotes']?.toString() ?? '',
    );
  }
}

class AiBudgetRecommendationItemModel {
  final String recommendationId;
  final String categoryName;
  final double currentLimitAmount;
  final double spentAmount;
  final double recommendedLimitAmount;
  final double predictedSpendAmount;
  final double adjustmentAmount;
  final String actionType;
  final String riskBefore;
  final String riskAfter;
  final String riskLevel;
  final double confidence;
  final String elasticity;
  final List<String> reasonCodes;
  final String explanation;
  final Map<String, dynamic> personalizationFactors;
  final Map<String, dynamic> expectedImpact;
  final String reason;

  const AiBudgetRecommendationItemModel({
    required this.recommendationId,
    required this.categoryName,
    required this.currentLimitAmount,
    required this.spentAmount,
    required this.recommendedLimitAmount,
    required this.predictedSpendAmount,
    required this.adjustmentAmount,
    required this.actionType,
    required this.riskBefore,
    required this.riskAfter,
    required this.riskLevel,
    required this.confidence,
    required this.elasticity,
    required this.reasonCodes,
    required this.explanation,
    required this.personalizationFactors,
    required this.expectedImpact,
    required this.reason,
  });

  factory AiBudgetRecommendationItemModel.fromJson(Map<String, dynamic> json) {
    final categoryName = json['categoryName']?.toString() ?? '';
    return AiBudgetRecommendationItemModel(
      recommendationId: json['recommendationId']?.toString().isNotEmpty == true
          ? json['recommendationId'].toString()
          : _fallbackBudgetRecommendationId(categoryName),
      categoryName: categoryName,
      currentLimitAmount: (json['currentLimitAmount'] as num? ?? 0.0)
          .toDouble(),
      spentAmount: (json['spentAmount'] as num? ?? 0.0).toDouble(),
      recommendedLimitAmount: (json['recommendedLimitAmount'] as num? ?? 0.0)
          .toDouble(),
      predictedSpendAmount: (json['predictedSpendAmount'] as num? ?? 0.0)
          .toDouble(),
      adjustmentAmount: (json['adjustmentAmount'] as num? ?? 0.0).toDouble(),
      actionType: json['actionType']?.toString() ?? 'keep',
      riskBefore: json['riskBefore']?.toString() ?? 'low',
      riskAfter: json['riskAfter']?.toString() ?? 'low',
      riskLevel: json['riskLevel']?.toString() ?? 'low',
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      elasticity: json['elasticity']?.toString() ?? 'medium',
      reasonCodes:
          (json['reasonCodes'] as List?)?.map((e) => e.toString()).toList() ??
          <String>[],
      explanation: json['explanation']?.toString() ?? '',
      personalizationFactors:
          json['personalizationFactors'] is Map<String, dynamic>
          ? json['personalizationFactors'] as Map<String, dynamic>
          : <String, dynamic>{},
      expectedImpact: json['expectedImpact'] is Map<String, dynamic>
          ? json['expectedImpact'] as Map<String, dynamic>
          : <String, dynamic>{},
      reason: json['reason']?.toString() ?? '',
    );
  }
}

String _fallbackBudgetRecommendationId(String categoryName) {
  final now = DateTime.now();
  final month = now.month.toString().padLeft(2, '0');
  final safeCategory = categoryName.trim().replaceAll(RegExp(r'\s+'), '_');
  return 'budget:${now.year}-$month:${safeCategory.isEmpty ? 'unknown' : safeCategory}';
}

class AiBudgetingModel {
  final String method;
  final String modelVersion;
  final double targetSavingsAmount;
  final double recommendedTotalBudget;
  final double expectedSavingsAmount;
  final double confidence;
  final String strategy;
  final List<AiBudgetRecommendationItemModel> items;
  final String summary;

  const AiBudgetingModel({
    required this.method,
    required this.modelVersion,
    required this.targetSavingsAmount,
    required this.recommendedTotalBudget,
    required this.expectedSavingsAmount,
    required this.confidence,
    required this.strategy,
    required this.items,
    required this.summary,
  });

  factory AiBudgetingModel.fromJson(Map<String, dynamic> json) {
    return AiBudgetingModel(
      method: json['method']?.toString() ?? '',
      modelVersion: json['modelVersion']?.toString() ?? 'v1',
      targetSavingsAmount: (json['targetSavingsAmount'] as num? ?? 0.0)
          .toDouble(),
      recommendedTotalBudget: (json['recommendedTotalBudget'] as num? ?? 0.0)
          .toDouble(),
      expectedSavingsAmount: (json['expectedSavingsAmount'] as num? ?? 0.0)
          .toDouble(),
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      strategy: json['strategy']?.toString() ?? 'balanced',
      items:
          (json['items'] as List?)
              ?.map(
                (e) => AiBudgetRecommendationItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          <AiBudgetRecommendationItemModel>[],
      summary: json['summary']?.toString() ?? '',
    );
  }
}

class AnalyticsModel {
  final int financialHealthScore;
  final String cashFlowTrend; // 'improving', 'stable', 'worsening'
  final double monthlyForecast;
  final List<AnomalyModel> anomalies;
  final BudgetRiskModel budgetRisk;
  final List<SavingGoalProjectionModel> savingGoalProjections;
  final List<InsightModel> insights;
  final ForecastingModel? forecasting;
  final AiBudgetingModel? aiBudgeting;

  const AnalyticsModel({
    required this.financialHealthScore,
    required this.cashFlowTrend,
    required this.monthlyForecast,
    required this.anomalies,
    required this.budgetRisk,
    required this.savingGoalProjections,
    required this.insights,
    this.forecasting,
    this.aiBudgeting,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    final anomaliesList =
        (json['anomalies'] as List?)
            ?.map((e) => AnomalyModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <AnomalyModel>[];

    final savingProjectionsList =
        (json['savingGoalProjections'] as List?)
            ?.map(
              (e) =>
                  SavingGoalProjectionModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        <SavingGoalProjectionModel>[];

    final insightsList =
        (json['insights'] as List?)
            ?.map((e) => InsightModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <InsightModel>[];

    final budgetRiskObj = json['budgetRisk'] != null
        ? BudgetRiskModel.fromJson(json['budgetRisk'] as Map<String, dynamic>)
        : const BudgetRiskModel(riskLevel: 'low', message: '', items: []);

    final forecastingObj = json['forecasting'] != null
        ? ForecastingModel.fromJson(json['forecasting'] as Map<String, dynamic>)
        : null;

    final aiBudgetingObj = json['aiBudgeting'] != null
        ? AiBudgetingModel.fromJson(json['aiBudgeting'] as Map<String, dynamic>)
        : null;

    return AnalyticsModel(
      financialHealthScore: json['financialHealthScore'] as int? ?? 100,
      cashFlowTrend: json['cashFlowTrend']?.toString() ?? 'stable',
      monthlyForecast: (json['monthlyForecast'] as num? ?? 0.0).toDouble(),
      anomalies: anomaliesList,
      budgetRisk: budgetRiskObj,
      savingGoalProjections: savingProjectionsList,
      insights: insightsList,
      forecasting: forecastingObj,
      aiBudgeting: aiBudgetingObj,
    );
  }
}
