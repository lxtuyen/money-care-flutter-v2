class ForecastingSummaryModel {
  final int evaluatedRuns;
  final String latestModelName;
  final double? mae;
  final double? rmse;
  final double? mape;
  final double? directionalAccuracy;
  final String? lastEvaluatedAt;

  const ForecastingSummaryModel({
    required this.evaluatedRuns,
    required this.latestModelName,
    this.mae,
    this.rmse,
    this.mape,
    this.directionalAccuracy,
    this.lastEvaluatedAt,
  });

  factory ForecastingSummaryModel.fromJson(Map<String, dynamic> json) {
    return ForecastingSummaryModel(
      evaluatedRuns: json['evaluatedRuns'] as int? ?? 0,
      latestModelName: json['latestModelName']?.toString() ?? '',
      mae: (json['mae'] as num?)?.toDouble(),
      rmse: (json['rmse'] as num?)?.toDouble(),
      mape: (json['mape'] as num?)?.toDouble(),
      directionalAccuracy: (json['directionalAccuracy'] as num?)?.toDouble(),
      lastEvaluatedAt: json['lastEvaluatedAt']?.toString(),
    );
  }
}

class BudgetingSummaryModel {
  final int evaluatedRuns;
  final double? adoptionRate;
  final double? overrunRate;
  final double? averageOverrunAmount;
  final String? lastEvaluatedAt;

  const BudgetingSummaryModel({
    required this.evaluatedRuns,
    this.adoptionRate,
    this.overrunRate,
    this.averageOverrunAmount,
    this.lastEvaluatedAt,
  });

  factory BudgetingSummaryModel.fromJson(Map<String, dynamic> json) {
    return BudgetingSummaryModel(
      evaluatedRuns: json['evaluatedRuns'] as int? ?? 0,
      adoptionRate: (json['adoptionRate'] as num?)?.toDouble(),
      overrunRate: (json['overrunRate'] as num?)?.toDouble(),
      averageOverrunAmount: (json['averageOverrunAmount'] as num?)?.toDouble(),
      lastEvaluatedAt: json['lastEvaluatedAt']?.toString(),
    );
  }
}

class ModelEvaluationSummaryModel {
  final ForecastingSummaryModel? forecasting;
  final BudgetingSummaryModel? budgeting;

  const ModelEvaluationSummaryModel({this.forecasting, this.budgeting});

  factory ModelEvaluationSummaryModel.fromJson(Map<String, dynamic> json) {
    return ModelEvaluationSummaryModel(
      forecasting: json['forecasting'] != null
          ? ForecastingSummaryModel.fromJson(
              json['forecasting'] as Map<String, dynamic>,
            )
          : null,
      budgeting: json['budgeting'] != null
          ? BudgetingSummaryModel.fromJson(
              json['budgeting'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ManualEvaluationResultModel {
  final int evaluatedCount;

  const ManualEvaluationResultModel({required this.evaluatedCount});

  factory ManualEvaluationResultModel.fromJson(Map<String, dynamic> json) {
    return ManualEvaluationResultModel(
      evaluatedCount: json['evaluatedCount'] as int? ?? 0,
    );
  }
}

class ForecastingTrainingResultModel {
  final String status;
  final String? reason;
  final String modelId;
  final bool artifactSaved;
  final String? artifactPath;
  final String? artifactScope;
  final Map<String, double> metrics;
  final int historyDays;
  final int trainingRows;
  final int? minimumRequiredDays;
  final int? minimumRequiredTransactions;

  const ForecastingTrainingResultModel({
    required this.status,
    this.reason,
    required this.modelId,
    required this.artifactSaved,
    this.artifactPath,
    this.artifactScope,
    required this.metrics,
    required this.historyDays,
    required this.trainingRows,
    this.minimumRequiredDays,
    this.minimumRequiredTransactions,
  });

  factory ForecastingTrainingResultModel.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json['metrics'];
    return ForecastingTrainingResultModel(
      status: json['status']?.toString() ?? '',
      reason: json['reason']?.toString(),
      modelId: json['modelId']?.toString() ?? '',
      artifactSaved: json['artifactSaved'] as bool? ?? false,
      artifactPath: json['artifactPath']?.toString(),
      artifactScope: json['artifactScope']?.toString(),
      metrics: rawMetrics is Map<String, dynamic>
          ? rawMetrics.map(
              (key, value) => MapEntry(key, (value as num? ?? 0).toDouble()),
            )
          : <String, double>{},
      historyDays: json['historyDays'] as int? ?? 0,
      trainingRows: json['trainingRows'] as int? ?? 0,
      minimumRequiredDays: json['minimumRequiredDays'] as int?,
      minimumRequiredTransactions: json['minimumRequiredTransactions'] as int?,
    );
  }
}

class ForecastingRecentRunModel {
  final int runId;
  final String modelName;
  final double predictedTotal;
  final double actualTotal;
  final double absoluteError;
  final double absolutePercentageError;
  final String evaluatedAt;

  const ForecastingRecentRunModel({
    required this.runId,
    required this.modelName,
    required this.predictedTotal,
    required this.actualTotal,
    required this.absoluteError,
    required this.absolutePercentageError,
    required this.evaluatedAt,
  });

  factory ForecastingRecentRunModel.fromJson(Map<String, dynamic> json) {
    return ForecastingRecentRunModel(
      runId: json['runId'] as int? ?? 0,
      modelName: json['modelName']?.toString() ?? '',
      predictedTotal: (json['predictedTotal'] as num? ?? 0).toDouble(),
      actualTotal: (json['actualTotal'] as num? ?? 0).toDouble(),
      absoluteError: (json['absoluteError'] as num? ?? 0).toDouble(),
      absolutePercentageError: (json['absolutePercentageError'] as num? ?? 0)
          .toDouble(),
      evaluatedAt: json['evaluatedAt']?.toString() ?? '',
    );
  }
}

class CategoryMetricModel {
  final String categoryName;
  final double mape;
  final int evaluatedRuns;

  const CategoryMetricModel({
    required this.categoryName,
    required this.mape,
    required this.evaluatedRuns,
  });

  factory CategoryMetricModel.fromJson(Map<String, dynamic> json) {
    return CategoryMetricModel(
      categoryName: json['categoryName']?.toString() ?? '',
      mape: (json['mape'] as num? ?? 0).toDouble(),
      evaluatedRuns: json['evaluatedRuns'] as int? ?? 0,
    );
  }
}

class ForecastingEvaluationModel {
  final ForecastingSummaryModel summary;
  final List<ForecastingRecentRunModel> recentRuns;
  final List<CategoryMetricModel> categoryMetrics;

  const ForecastingEvaluationModel({
    required this.summary,
    required this.recentRuns,
    required this.categoryMetrics,
  });

  factory ForecastingEvaluationModel.fromJson(Map<String, dynamic> json) {
    return ForecastingEvaluationModel(
      summary: ForecastingSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      recentRuns:
          (json['recentRuns'] as List?)
              ?.map(
                (e) => ForecastingRecentRunModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      categoryMetrics:
          (json['categoryMetrics'] as List?)
              ?.map(
                (e) => CategoryMetricModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class BudgetingRecentRunModel {
  final int runId;
  final double recommendedTotalBudget;
  final double actualTotalExpense;
  final double overrunAmount;
  final bool wasOverBudget;

  const BudgetingRecentRunModel({
    required this.runId,
    required this.recommendedTotalBudget,
    required this.actualTotalExpense,
    required this.overrunAmount,
    required this.wasOverBudget,
  });

  factory BudgetingRecentRunModel.fromJson(Map<String, dynamic> json) {
    return BudgetingRecentRunModel(
      runId: json['runId'] as int? ?? 0,
      recommendedTotalBudget: (json['recommendedTotalBudget'] as num? ?? 0)
          .toDouble(),
      actualTotalExpense: (json['actualTotalExpense'] as num? ?? 0).toDouble(),
      overrunAmount: (json['overrunAmount'] as num? ?? 0).toDouble(),
      wasOverBudget: json['wasOverBudget'] as bool? ?? false,
    );
  }
}

class BudgetingEvaluationModel {
  final BudgetingSummaryModel summary;
  final List<BudgetingRecentRunModel> recentRuns;

  const BudgetingEvaluationModel({
    required this.summary,
    required this.recentRuns,
  });

  factory BudgetingEvaluationModel.fromJson(Map<String, dynamic> json) {
    return BudgetingEvaluationModel(
      summary: BudgetingSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      recentRuns:
          (json['recentRuns'] as List?)
              ?.map(
                (e) =>
                    BudgetingRecentRunModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
