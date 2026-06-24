class ChatbotExpenseAnalysisModel {
  final int version;
  final String type;
  final String message;
  final ChatbotOverviewModel? overview;
  final List<ChatbotTopCategoryModel> topCategories;
  final ChatbotForecastModel? forecast;
  final List<ChatbotAnomalyModel> anomalies;
  final ChatbotBudgetRiskModel? budgetRisk;
  final List<ChatbotRecommendationModel> recommendations;
  final ChatbotEmptyStateModel? emptyState;

  const ChatbotExpenseAnalysisModel({
    required this.version,
    required this.type,
    required this.message,
    required this.overview,
    required this.topCategories,
    required this.forecast,
    required this.anomalies,
    required this.budgetRisk,
    required this.recommendations,
    required this.emptyState,
  });

  factory ChatbotExpenseAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ChatbotExpenseAnalysisModel(
      version: _asInt(json['version']),
      type: json['type']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      overview: json['overview'] is Map
          ? ChatbotOverviewModel.fromJson(_asMap(json['overview']))
          : null,
      topCategories: _asList(
        json['topCategories'],
      ).map((item) => ChatbotTopCategoryModel.fromJson(_asMap(item))).toList(),
      forecast: json['forecast'] is Map
          ? ChatbotForecastModel.fromJson(_asMap(json['forecast']))
          : null,
      anomalies: _asList(
        json['anomalies'],
      ).map((item) => ChatbotAnomalyModel.fromJson(_asMap(item))).toList(),
      budgetRisk: json['budgetRisk'] is Map
          ? ChatbotBudgetRiskModel.fromJson(_asMap(json['budgetRisk']))
          : null,
      recommendations: _asList(json['recommendations'])
          .map((item) => ChatbotRecommendationModel.fromJson(_asMap(item)))
          .toList(),
      emptyState: json['emptyState'] is Map
          ? ChatbotEmptyStateModel.fromJson(_asMap(json['emptyState']))
          : null,
    );
  }
}

class ChatbotOverviewModel {
  final int financialHealthScore;
  final String cashFlowTrend;
  final double monthlyForecast;
  final String periodLabel;
  final String summary;
  final double? expenseTotal;
  final double? incomeTotal;
  final double? netBalance;

  const ChatbotOverviewModel({
    required this.financialHealthScore,
    required this.cashFlowTrend,
    required this.monthlyForecast,
    required this.periodLabel,
    required this.summary,
    required this.expenseTotal,
    required this.incomeTotal,
    required this.netBalance,
  });

  factory ChatbotOverviewModel.fromJson(Map<String, dynamic> json) {
    return ChatbotOverviewModel(
      financialHealthScore: _asInt(json['financialHealthScore']),
      cashFlowTrend: json['cashFlowTrend']?.toString() ?? '',
      monthlyForecast: _asDouble(json['monthlyForecast']),
      periodLabel: json['periodLabel']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      expenseTotal: _asNullableDouble(json['expenseTotal']),
      incomeTotal: _asNullableDouble(json['incomeTotal']),
      netBalance: _asNullableDouble(json['netBalance']),
    );
  }
}

class ChatbotTopCategoryModel {
  final String categoryName;
  final double amount;
  final String trend;
  final String note;
  final int? percentageOfExpenses;

  const ChatbotTopCategoryModel({
    required this.categoryName,
    required this.amount,
    required this.trend,
    required this.note,
    required this.percentageOfExpenses,
  });

  factory ChatbotTopCategoryModel.fromJson(Map<String, dynamic> json) {
    return ChatbotTopCategoryModel(
      categoryName: json['categoryName']?.toString() ?? '',
      amount: _asDouble(json['amount']),
      trend: json['trend']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      percentageOfExpenses: json['percentageOfExpenses'] == null
          ? null
          : _asInt(json['percentageOfExpenses']),
    );
  }
}

class ChatbotForecastModel {
  final ChatbotForecastProjectionModel? currentMonthProjection;
  final List<ChatbotRiskWindowModel> riskWindows;

  const ChatbotForecastModel({
    required this.currentMonthProjection,
    required this.riskWindows,
  });

  factory ChatbotForecastModel.fromJson(Map<String, dynamic> json) {
    return ChatbotForecastModel(
      currentMonthProjection: json['currentMonthProjection'] is Map
          ? ChatbotForecastProjectionModel.fromJson(
              _asMap(json['currentMonthProjection']),
            )
          : null,
      riskWindows: _asList(
        json['riskWindows'],
      ).map((item) => ChatbotRiskWindowModel.fromJson(_asMap(item))).toList(),
    );
  }
}

class ChatbotForecastProjectionModel {
  final double? totalForecast;
  final double? predictedRemainingAmount;
  final double confidence;
  final String riskLevel;
  final String modelNotes;

  const ChatbotForecastProjectionModel({
    required this.totalForecast,
    required this.predictedRemainingAmount,
    required this.confidence,
    required this.riskLevel,
    required this.modelNotes,
  });

  factory ChatbotForecastProjectionModel.fromJson(Map<String, dynamic> json) {
    return ChatbotForecastProjectionModel(
      totalForecast: _asNullableDouble(json['totalForecast']),
      predictedRemainingAmount: _asNullableDouble(
        json['predictedRemainingAmount'],
      ),
      confidence: _asDouble(json['confidence']),
      riskLevel: json['riskLevel']?.toString() ?? '',
      modelNotes: json['modelNotes']?.toString() ?? '',
    );
  }
}

class ChatbotRiskWindowModel {
  final String periodStart;
  final String periodEnd;
  final String riskLevel;
  final double? predictedAmount;
  final String reason;

  const ChatbotRiskWindowModel({
    required this.periodStart,
    required this.periodEnd,
    required this.riskLevel,
    required this.predictedAmount,
    required this.reason,
  });

  factory ChatbotRiskWindowModel.fromJson(Map<String, dynamic> json) {
    return ChatbotRiskWindowModel(
      periodStart: json['periodStart']?.toString() ?? '',
      periodEnd: json['periodEnd']?.toString() ?? '',
      riskLevel: json['riskLevel']?.toString() ?? '',
      predictedAmount: _asNullableDouble(json['predictedAmount']),
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class ChatbotAnomalyModel {
  final int transactionId;
  final double amount;
  final String date;
  final String categoryName;
  final String reason;

  const ChatbotAnomalyModel({
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.categoryName,
    required this.reason,
  });

  factory ChatbotAnomalyModel.fromJson(Map<String, dynamic> json) {
    return ChatbotAnomalyModel(
      transactionId: _asInt(json['transactionId']),
      amount: _asDouble(json['amount']),
      date: json['date']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class ChatbotBudgetRiskModel {
  final String riskLevel;
  final String message;
  final List<ChatbotBudgetRiskItemModel> items;

  const ChatbotBudgetRiskModel({
    required this.riskLevel,
    required this.message,
    required this.items,
  });

  factory ChatbotBudgetRiskModel.fromJson(Map<String, dynamic> json) {
    return ChatbotBudgetRiskModel(
      riskLevel: json['riskLevel']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      items: _asList(json['items'])
          .map((item) => ChatbotBudgetRiskItemModel.fromJson(_asMap(item)))
          .toList(),
    );
  }
}

class ChatbotBudgetRiskItemModel {
  final String categoryName;
  final double limitAmount;
  final double spentAmount;
  final double riskScore;
  final String status;
  final double? forecastAmount;

  const ChatbotBudgetRiskItemModel({
    required this.categoryName,
    required this.limitAmount,
    required this.spentAmount,
    required this.riskScore,
    required this.status,
    required this.forecastAmount,
  });

  factory ChatbotBudgetRiskItemModel.fromJson(Map<String, dynamic> json) {
    return ChatbotBudgetRiskItemModel(
      categoryName: json['categoryName']?.toString() ?? '',
      limitAmount: _asDouble(json['limitAmount']),
      spentAmount: _asDouble(json['spentAmount']),
      riskScore: _asDouble(json['riskScore']),
      status: json['status']?.toString() ?? '',
      forecastAmount: _asNullableDouble(json['forecastAmount']),
    );
  }
}

class ChatbotRecommendationModel {
  final String title;
  final String description;
  final String severity;

  const ChatbotRecommendationModel({
    required this.title,
    required this.description,
    required this.severity,
  });

  factory ChatbotRecommendationModel.fromJson(Map<String, dynamic> json) {
    return ChatbotRecommendationModel(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      severity: json['severity']?.toString() ?? '',
    );
  }
}

class ChatbotEmptyStateModel {
  final String title;
  final String message;

  const ChatbotEmptyStateModel({required this.title, required this.message});

  factory ChatbotEmptyStateModel.fromJson(Map<String, dynamic> json) {
    return ChatbotEmptyStateModel(
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return const [];
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
