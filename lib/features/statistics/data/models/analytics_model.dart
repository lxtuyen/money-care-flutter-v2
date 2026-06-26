import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class AnomalyModel {
  final int transactionId;
  final double amount;
  final String date;
  final String categoryName;
  final int? categoryId;
  final String? categoryIcon;
  final String type;
  final String? note;
  final int? walletId;
  final String? walletName;
  final String reason;

  const AnomalyModel({
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.categoryName,
    this.categoryId,
    this.categoryIcon,
    this.type = 'expense',
    this.note,
    this.walletId,
    this.walletName,
    required this.reason,
  });

  factory AnomalyModel.fromJson(Map<String, dynamic> json) {
    return AnomalyModel(
      transactionId: json['transactionId'] as int? ?? 0,
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      date: json['date']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      categoryId: json['categoryId'] as int?,
      categoryIcon: json['categoryIcon']?.toString(),
      type: json['type']?.toString() ?? 'expense',
      note: json['note']?.toString(),
      walletId: json['walletId'] as int?,
      walletName: json['walletName']?.toString(),
      reason: json['reason']?.toString() ?? '',
    );
  }

  /// Chuyển anomaly thành TransactionEntity để hiển thị trong danh sách.
  TransactionEntity toTransactionEntity() {
    return TransactionEntity(
      id: transactionId,
      amount: amount.toInt(),
      type: type,
      transactionDate: DateTime.tryParse(date),
      note: note ?? reason,
      walletId: walletId,
      walletName: walletName,
      category: CategoryEntity(
        id: categoryId,
        name: categoryName,
        icon: categoryIcon ?? '⚠️',
        type: type,
      ),
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
      predictedAmount: (json['predictedAmount'] as num? ?? json['predicted_amount'] as num? ?? 0.0).toDouble(),
    );
  }
}

class RecurringMarkerModel {
  final String date;
  final String label;
  final double amount;

  const RecurringMarkerModel({
    required this.date,
    required this.label,
    required this.amount,
  });

  factory RecurringMarkerModel.fromJson(Map<String, dynamic> json) {
    return RecurringMarkerModel(
      date: json['date']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
    );
  }
}

class CategoryForecastModel {
  final String categoryName;
  final double predictedAmount;
  final double confidence;
  final String trend;
  final int dataPoints;
  final double? actualAmount;
  final double? remainingForecastAmount;
  final String? riskLevel;
  final List<String> reasonCodes;
  final double? fixedAmount;
  final double? flexibleAmount;

  const CategoryForecastModel({
    required this.categoryName,
    required this.predictedAmount,
    required this.confidence,
    required this.trend,
    required this.dataPoints,
    this.actualAmount,
    this.remainingForecastAmount,
    this.riskLevel,
    required this.reasonCodes,
    this.fixedAmount,
    this.flexibleAmount,
  });

  factory CategoryForecastModel.fromJson(Map<String, dynamic> json) {
    return CategoryForecastModel(
      categoryName:
          json['categoryName']?.toString() ??
          json['category_name']?.toString() ??
          '',
      predictedAmount:
          (json['predictedAmount'] as num? ??
                  json['predicted_amount'] as num? ??
                  0.0)
              .toDouble(),
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      trend: json['trend']?.toString() ?? 'stable',
      dataPoints:
          json['dataPoints'] as int? ?? json['data_points'] as int? ?? 0,
      actualAmount: json['actualAmount'] != null
          ? (json['actualAmount'] as num).toDouble()
          : (json['actual_amount'] != null
                ? (json['actual_amount'] as num).toDouble()
                : null),
      remainingForecastAmount: json['remainingForecastAmount'] != null
          ? (json['remainingForecastAmount'] as num).toDouble()
          : (json['remaining_forecast_amount'] != null
                ? (json['remaining_forecast_amount'] as num).toDouble()
                : null),
      riskLevel:
          json['riskLevel']?.toString() ?? json['risk_level']?.toString(),
      reasonCodes:
          (json['reasonCodes'] as List? ?? json['reason_codes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      fixedAmount: json['fixedAmount'] != null
          ? (json['fixedAmount'] as num).toDouble()
          : (json['fixed_amount'] != null
                ? (json['fixed_amount'] as num).toDouble()
                : null),
      flexibleAmount: json['flexibleAmount'] != null
          ? (json['flexibleAmount'] as num).toDouble()
          : (json['flexible_amount'] != null
                ? (json['flexible_amount'] as num).toDouble()
                : null),
    );
  }
}

class WeeklyForecastModel {
  final int weekIndex;
  final String periodStart;
  final String periodEnd;
  final double predictedAmount;
  final double actualAmount;
  final String riskLevel;

  const WeeklyForecastModel({
    required this.weekIndex,
    required this.periodStart,
    required this.periodEnd,
    required this.predictedAmount,
    required this.actualAmount,
    required this.riskLevel,
  });

  factory WeeklyForecastModel.fromJson(Map<String, dynamic> json) {
    return WeeklyForecastModel(
      weekIndex: json['weekIndex'] as int? ?? json['week_index'] as int? ?? 1,
      periodStart:
          json['periodStart']?.toString() ??
          json['period_start']?.toString() ??
          '',
      periodEnd:
          json['periodEnd']?.toString() ?? json['period_end']?.toString() ?? '',
      predictedAmount:
          (json['predictedAmount'] as num? ??
                  json['predicted_amount'] as num? ??
                  0.0)
              .toDouble(),
      actualAmount:
          (json['actualAmount'] as num? ?? json['actual_amount'] as num? ?? 0.0)
              .toDouble(),
      riskLevel:
          json['riskLevel']?.toString() ??
          json['risk_level']?.toString() ??
          'low',
    );
  }
}

class ForecastRiskWindowModel {
  final String periodStart;
  final String periodEnd;
  final String riskLevel;
  final double predictedAmount;
  final String reason;
  final List<String> reasonCodes;

  const ForecastRiskWindowModel({
    required this.periodStart,
    required this.periodEnd,
    required this.riskLevel,
    required this.predictedAmount,
    required this.reason,
    required this.reasonCodes,
  });

  factory ForecastRiskWindowModel.fromJson(Map<String, dynamic> json) {
    return ForecastRiskWindowModel(
      periodStart:
          json['periodStart']?.toString() ??
          json['period_start']?.toString() ??
          '',
      periodEnd:
          json['periodEnd']?.toString() ?? json['period_end']?.toString() ?? '',
      riskLevel:
          json['riskLevel']?.toString() ??
          json['risk_level']?.toString() ??
          'low',
      predictedAmount:
          (json['predictedAmount'] as num? ??
                  json['predicted_amount'] as num? ??
                  0.0)
              .toDouble(),
      reason: json['reason']?.toString() ?? '',
      reasonCodes:
          (json['reasonCodes'] as List? ?? json['reason_codes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
    );
  }
}

class ForecastingModel {
  final String method;
  final String modelVersion;
  final String periodType;
  final String forecastMode;
  final int targetMonth;
  final int targetYear;
  final String periodStart;
  final String periodEnd;
  final double actualAmount;
  final double predictedRemainingAmount;
  final double totalForecast;
  final double confidence;
  final String riskLevel;
  final String modelNotes;
  final List<ForecastPointModel> dailyPoints;
  final List<CategoryForecastModel> categoryForecasts;
  final List<WeeklyForecastModel> weeklyForecasts;
  final List<ForecastRiskWindowModel> riskWindows;
  final List<RecurringMarkerModel> recurringMarkers;

  const ForecastingModel({
    required this.method,
    required this.modelVersion,
    required this.periodType,
    required this.forecastMode,
    required this.targetMonth,
    required this.targetYear,
    required this.periodStart,
    required this.periodEnd,
    required this.actualAmount,
    required this.predictedRemainingAmount,
    required this.totalForecast,
    required this.confidence,
    required this.riskLevel,
    required this.modelNotes,
    required this.dailyPoints,
    required this.categoryForecasts,
    required this.weeklyForecasts,
    required this.riskWindows,
    required this.recurringMarkers,
  });

  factory ForecastingModel.fromJson(Map<String, dynamic> json) {
    return ForecastingModel(
      method: json['method']?.toString() ?? '',
      modelVersion:
          json['modelVersion']?.toString() ??
          json['model_version']?.toString() ??
          'v1',
      periodType:
          json['periodType']?.toString() ??
          json['period_type']?.toString() ??
          'day',
      forecastMode:
          json['forecastMode']?.toString() ??
          json['forecast_mode']?.toString() ??
          'legacy_30_days',
      targetMonth:
          json['targetMonth'] as int? ??
          json['target_month'] as int? ??
          DateTime.now().month,
      targetYear:
          json['targetYear'] as int? ??
          json['target_year'] as int? ??
          DateTime.now().year,
      periodStart:
          json['periodStart']?.toString() ??
          json['period_start']?.toString() ??
          '',
      periodEnd:
          json['periodEnd']?.toString() ?? json['period_end']?.toString() ?? '',
      actualAmount:
          (json['actualAmount'] as num? ?? json['actual_amount'] as num? ?? 0.0)
              .toDouble(),
      predictedRemainingAmount:
          (json['predictedRemainingAmount'] as num? ??
                  json['predicted_remaining_amount'] as num? ??
                  0.0)
              .toDouble(),
      totalForecast:
          (json['totalForecast'] as num? ??
                  json['total_forecast'] as num? ??
                  0.0)
              .toDouble(),
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      riskLevel:
          json['riskLevel']?.toString() ??
          json['risk_level']?.toString() ??
          'low',
      modelNotes:
          json['modelNotes']?.toString() ??
          json['model_notes']?.toString() ??
          '',
      dailyPoints:
          (json['dailyPoints'] as List? ?? json['daily_points'] as List?)
              ?.map(
                (e) => ForecastPointModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <ForecastPointModel>[],
      categoryForecasts:
          (json['categoryForecasts'] as List? ??
                  json['category_forecasts'] as List?)
              ?.map(
                (e) =>
                    CategoryForecastModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <CategoryForecastModel>[],
      weeklyForecasts:
          (json['weeklyForecasts'] as List? ??
                  json['weekly_forecasts'] as List?)
              ?.map(
                (e) => WeeklyForecastModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <WeeklyForecastModel>[],
      riskWindows:
          (json['riskWindows'] as List? ?? json['risk_windows'] as List?)
              ?.map(
                (e) =>
                    ForecastRiskWindowModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <ForecastRiskWindowModel>[],
      recurringMarkers:
          (json['recurringMarkers'] as List? ?? json['recurring_markers'] as List?)
              ?.map(
                (e) =>
                    RecurringMarkerModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <RecurringMarkerModel>[],
    );
  }
}

class BudgetExceedPredictionModel {
  final String categoryName;
  final double limitAmount;
  final double actualAmount;
  final double totalForecast;
  final double exceedAmount;
  final bool willExceed;
  final double exceedProbability;
  final double confidence;
  final String trend;
  final String riskLevel;
  final double actualRatio;
  final double forecastRatio;
  final double? expectedTodayRatio;
  final double? expectedTodayAmount;
  final double? dailyForecastAmount;
  final bool isFrequent;

  const BudgetExceedPredictionModel({
    required this.categoryName,
    required this.limitAmount,
    required this.actualAmount,
    required this.totalForecast,
    required this.exceedAmount,
    required this.willExceed,
    required this.exceedProbability,
    required this.confidence,
    required this.trend,
    required this.riskLevel,
    required this.actualRatio,
    required this.forecastRatio,
    this.expectedTodayRatio,
    this.expectedTodayAmount,
    this.dailyForecastAmount,
    this.isFrequent = false,
  });

  factory BudgetExceedPredictionModel.fromJson(Map<String, dynamic> json) {
    return BudgetExceedPredictionModel(
      categoryName: json['categoryName']?.toString() ?? '',
      limitAmount: (json['limitAmount'] as num? ?? 0.0).toDouble(),
      actualAmount: (json['actualAmount'] as num? ?? 0.0).toDouble(),
      totalForecast: (json['totalForecast'] as num? ?? 0.0).toDouble(),
      exceedAmount: (json['exceedAmount'] as num? ?? 0.0).toDouble(),
      willExceed: json['willExceed'] as bool? ?? false,
      exceedProbability: (json['exceedProbability'] as num? ?? 0.0).toDouble(),
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      trend: json['trend']?.toString() ?? 'stable',
      riskLevel: json['riskLevel']?.toString() ?? 'low',
      actualRatio: (json['actualRatio'] as num? ?? 0.0).toDouble(),
      forecastRatio: (json['forecastRatio'] as num? ?? 0.0).toDouble(),
      expectedTodayRatio: json['expectedTodayRatio'] != null
          ? (json['expectedTodayRatio'] as num).toDouble()
          : null,
      expectedTodayAmount: json['expectedTodayAmount'] != null
          ? (json['expectedTodayAmount'] as num).toDouble()
          : null,
      dailyForecastAmount: json['dailyForecastAmount'] != null
          ? (json['dailyForecastAmount'] as num).toDouble()
          : null,
      isFrequent: json['isFrequent'] as bool? ?? false,
    );
  }
}

class AiBudgetRecommendationItemModel {  final String recommendationId;
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

class FixedCostItemModel {
  final String description;
  final double amount;
  final String frequency;

  const FixedCostItemModel({
    required this.description,
    required this.amount,
    required this.frequency,
  });

  factory FixedCostItemModel.fromJson(Map<String, dynamic> json) {
    return FixedCostItemModel(
      description: json['description']?.toString() ?? '',
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      frequency: json['frequency']?.toString() ?? 'monthly',
    );
  }
}

class FixedCostCategoryModel {
  final String categoryName;
  final double totalAmount;
  final List<FixedCostItemModel> items;

  const FixedCostCategoryModel({
    required this.categoryName,
    required this.totalAmount,
    required this.items,
  });

  factory FixedCostCategoryModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List?;
    final itemsList = list != null
        ? list
              .map((e) => FixedCostItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <FixedCostItemModel>[];

    return FixedCostCategoryModel(
      categoryName: json['categoryName']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num? ?? 0.0).toDouble(),
      items: itemsList,
    );
  }
}

class FixedCostBudgetModel {
  final double totalFixedCost;
  final List<FixedCostCategoryModel> categories;

  const FixedCostBudgetModel({
    required this.totalFixedCost,
    required this.categories,
  });

  factory FixedCostBudgetModel.fromJson(Map<String, dynamic> json) {
    final list = json['categories'] as List?;
    final categoriesList = list != null
        ? list
              .map((e) => FixedCostCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <FixedCostCategoryModel>[];

    return FixedCostBudgetModel(
      totalFixedCost: (json['totalFixedCost'] as num? ?? 0.0).toDouble(),
      categories: categoriesList,
    );
  }
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
  final List<BudgetExceedPredictionModel> budgetExceedPredictions;
  final FixedCostBudgetModel? fixedCostBudget;
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
    required this.budgetExceedPredictions,
    this.fixedCostBudget,
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
      budgetExceedPredictions:
          (json['budgetExceedPredictions'] as List?)
              ?.map(
                (e) => BudgetExceedPredictionModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          <BudgetExceedPredictionModel>[],
      fixedCostBudget: json['fixedCostBudget'] != null
          ? FixedCostBudgetModel.fromJson(
              json['fixedCostBudget'] as Map<String, dynamic>,
            )
          : null,
      summary: json['summary']?.toString() ?? '',
    );
  }
}

class UnpaidRecurringModel {
  final String categoryName;
  final String description;
  final int? expectedDay;
  final double expectedAmount;
  final String status;

  const UnpaidRecurringModel({
    required this.categoryName,
    required this.description,
    this.expectedDay,
    required this.expectedAmount,
    required this.status,
  });

  factory UnpaidRecurringModel.fromJson(Map<String, dynamic> json) {
    return UnpaidRecurringModel(
      categoryName: json['categoryName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      expectedDay: json['expectedDay'] as int?,
      expectedAmount: (json['expectedAmount'] as num? ?? 0.0).toDouble(),
      status: json['status']?.toString() ?? 'unpaid',
    );
  }
}

class HabitSuggestionModel {
  final String habitName;
  final String categoryName;
  final int currentMonthCount;
  final double currentMonthTotal;
  final double avgPerTransaction;
  final int projectedMonthCount;
  final double projectedMonthTotal;
  final int suggestedCount;
  final double potentialSavings;
  final String suggestionText;
  final bool isEarlyEstimate;

  const HabitSuggestionModel({
    required this.habitName,
    required this.categoryName,
    required this.currentMonthCount,
    required this.currentMonthTotal,
    required this.avgPerTransaction,
    required this.projectedMonthCount,
    required this.projectedMonthTotal,
    required this.suggestedCount,
    required this.potentialSavings,
    required this.suggestionText,
    this.isEarlyEstimate = false,
  });

  factory HabitSuggestionModel.fromJson(Map<String, dynamic> json) {
    return HabitSuggestionModel(
      habitName: json['habitName']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      currentMonthCount: json['currentMonthCount'] as int? ?? 0,
      currentMonthTotal: (json['currentMonthTotal'] as num? ?? 0.0).toDouble(),
      avgPerTransaction: (json['avgPerTransaction'] as num? ?? 0.0).toDouble(),
      projectedMonthCount: json['projectedMonthCount'] as int? ?? 0,
      projectedMonthTotal: (json['projectedMonthTotal'] as num? ?? 0.0).toDouble(),
      suggestedCount: json['suggestedCount'] as int? ?? 0,
      potentialSavings: (json['potentialSavings'] as num? ?? 0.0).toDouble(),
      suggestionText: json['suggestionText']?.toString() ?? '',
      isEarlyEstimate: json['isEarlyEstimate'] as bool? ?? false,
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
  final ForecastingModel? currentMonthProjection;
  final ForecastingModel? nextMonthForecast;
  final GoalAchievementPredictionSummaryModel? goalAchievement;
  final List<UnpaidRecurringModel> unpaidRecurring;
  final List<HabitSuggestionModel> habitSuggestions;

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
    this.currentMonthProjection,
    this.nextMonthForecast,
    this.goalAchievement,
    this.unpaidRecurring = const [],
    this.habitSuggestions = const [],
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

    final forecastingJson = json['forecasting'] as Map<String, dynamic>?;
    ForecastingModel? currentMonthProjectionObj;
    ForecastingModel? nextMonthForecastObj;
    ForecastingModel? forecastingLegacy;

    if (forecastingJson != null) {
      if (forecastingJson.containsKey('currentMonthProjection') ||
          forecastingJson.containsKey('nextMonthForecast')) {
        if (forecastingJson['currentMonthProjection'] != null) {
          currentMonthProjectionObj = ForecastingModel.fromJson(
            forecastingJson['currentMonthProjection'] as Map<String, dynamic>,
          );
        }
        if (forecastingJson['nextMonthForecast'] != null) {
          nextMonthForecastObj = ForecastingModel.fromJson(
            forecastingJson['nextMonthForecast'] as Map<String, dynamic>,
          );
        }
      } else {
        forecastingLegacy = ForecastingModel.fromJson(forecastingJson);
      }
    }

    final aiBudgetingObj = json['aiBudgeting'] != null
        ? AiBudgetingModel.fromJson(json['aiBudgeting'] as Map<String, dynamic>)
        : null;
    final goalAchievementObj = json['goalAchievement'] is Map<String, dynamic>
        ? GoalAchievementPredictionSummaryModel.fromJson(
            json['goalAchievement'] as Map<String, dynamic>,
          )
        : null;

    return AnalyticsModel(
      financialHealthScore: json['financialHealthScore'] as int? ?? 100,
      cashFlowTrend: json['cashFlowTrend']?.toString() ?? 'stable',
      monthlyForecast: (json['monthlyForecast'] as num? ?? 0.0).toDouble(),
      anomalies: anomaliesList,
      budgetRisk: budgetRiskObj,
      savingGoalProjections: savingProjectionsList,
      insights: insightsList,
      forecasting: forecastingLegacy ?? currentMonthProjectionObj,
      aiBudgeting: aiBudgetingObj,
      currentMonthProjection: currentMonthProjectionObj,
      nextMonthForecast: nextMonthForecastObj,
      goalAchievement: goalAchievementObj,
      unpaidRecurring:
          (json['unpaidRecurring'] as List?)
              ?.map((e) => UnpaidRecurringModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <UnpaidRecurringModel>[],
      habitSuggestions:
          (json['habitSuggestions'] as List?)
              ?.map((e) => HabitSuggestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <HabitSuggestionModel>[],
    );
  }
}
