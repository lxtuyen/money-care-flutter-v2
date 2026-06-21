class CoupleReportSummaryEntity {
  final String month;
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final int transactionCount;
  final int expenseCount;

  const CoupleReportSummaryEntity({
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.transactionCount,
    required this.expenseCount,
  });

  factory CoupleReportSummaryEntity.fromJson(Map<String, dynamic> json) {
    return CoupleReportSummaryEntity(
      month: json['month']?.toString() ?? '',
      totalIncome: double.parse(json['totalIncome']?.toString() ?? '0'),
      totalExpense: double.parse(json['totalExpense']?.toString() ?? '0'),
      netBalance: double.parse(json['netBalance']?.toString() ?? '0'),
      transactionCount: json['transactionCount'] is int
          ? json['transactionCount'] as int
          : int.tryParse(json['transactionCount']?.toString() ?? '0') ?? 0,
      expenseCount: json['expenseCount'] is int
          ? json['expenseCount'] as int
          : int.tryParse(json['expenseCount']?.toString() ?? '0') ?? 0,
    );
  }
}

class CoupleTopCategoryEntity {
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final double amount;
  final double percentage;

  const CoupleTopCategoryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.amount,
    required this.percentage,
  });

  factory CoupleTopCategoryEntity.fromJson(Map<String, dynamic> json) {
    return CoupleTopCategoryEntity(
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName']?.toString() ?? 'Khác',
      categoryIcon: json['categoryIcon']?.toString() ?? '💰',
      amount: double.parse(json['amount']?.toString() ?? '0'),
      percentage: double.parse(json['percentage']?.toString() ?? '0'),
    );
  }
}

class CoupleMemberContributionReportEntity {
  final int userId;
  final String fullName;
  final double paidAmount;

  const CoupleMemberContributionReportEntity({
    required this.userId,
    required this.fullName,
    required this.paidAmount,
  });

  factory CoupleMemberContributionReportEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return CoupleMemberContributionReportEntity(
      userId: json['userId'] ?? 0,
      fullName: json['fullName']?.toString() ?? 'Thành viên',
      paidAmount: double.parse(json['paidAmount']?.toString() ?? '0'),
    );
  }
}

class CoupleBudgetProgressReportEntity {
  final int id;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final double amount;
  final double spentAmount;
  final double remainingAmount;
  final double usagePercentage;

  const CoupleBudgetProgressReportEntity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.amount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.usagePercentage,
  });

  factory CoupleBudgetProgressReportEntity.fromJson(Map<String, dynamic> json) {
    return CoupleBudgetProgressReportEntity(
      id: json['id'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName']?.toString() ?? 'Khác',
      categoryIcon: json['categoryIcon']?.toString() ?? '💰',
      amount: double.parse(json['amount']?.toString() ?? '0'),
      spentAmount: double.parse(json['spentAmount']?.toString() ?? '0'),
      remainingAmount: double.parse(json['remainingAmount']?.toString() ?? '0'),
      usagePercentage: double.parse(json['usagePercentage']?.toString() ?? '0'),
    );
  }
}

class CoupleSavingGoalPredictionEntity {
  final String? predictedCompletionDate;
  final int? daysRemaining;
  final double monthlyContributionRate;
  final double requiredMonthlyRate;
  final String status;
  final String riskLevel;
  final double shortfallAmount;
  final String? recommendedAction;
  final double confidence;

  const CoupleSavingGoalPredictionEntity({
    this.predictedCompletionDate,
    this.daysRemaining,
    required this.monthlyContributionRate,
    required this.requiredMonthlyRate,
    required this.status,
    required this.riskLevel,
    required this.shortfallAmount,
    this.recommendedAction,
    required this.confidence,
  });

  factory CoupleSavingGoalPredictionEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return CoupleSavingGoalPredictionEntity(
      predictedCompletionDate:
          json['predictedCompletionDate']?.toString(),
      daysRemaining: json['daysRemaining'] is int
          ? json['daysRemaining'] as int
          : int.tryParse(json['daysRemaining']?.toString() ?? ''),
      monthlyContributionRate: double.parse(
        json['monthlyContributionRate']?.toString() ?? '0',
      ),
      requiredMonthlyRate: double.parse(
        json['requiredMonthlyRate']?.toString() ?? '0',
      ),
      status: json['status']?.toString() ?? 'tracking',
      riskLevel: json['riskLevel']?.toString() ?? 'medium',
      shortfallAmount: double.parse(
        json['shortfallAmount']?.toString() ?? '0',
      ),
      recommendedAction: json['recommendedAction']?.toString(),
      confidence: double.parse(
        json['confidence']?.toString() ?? '0',
      ),
    );
  }
}

class CoupleSavingProgressReportEntity {
  final int id;
  final String name;
  final double target;
  final double savedAmount;
  final double progress;
  final String status;
  final DateTime? endDate;
  final DateTime? startDate;
  final CoupleSavingGoalPredictionEntity? prediction;

  const CoupleSavingProgressReportEntity({
    required this.id,
    required this.name,
    required this.target,
    required this.savedAmount,
    required this.progress,
    required this.status,
    this.endDate,
    this.startDate,
    this.prediction,
  });

  factory CoupleSavingProgressReportEntity.fromJson(Map<String, dynamic> json) {
    return CoupleSavingProgressReportEntity(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      target: double.parse(json['target']?.toString() ?? '0'),
      savedAmount: double.parse(json['savedAmount']?.toString() ?? '0'),
      progress: double.parse(json['progress']?.toString() ?? '0'),
      status: json['status']?.toString() ?? 'active',
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      prediction: json['prediction'] != null
          ? CoupleSavingGoalPredictionEntity.fromJson(
              Map<String, dynamic>.from(json['prediction'] as Map),
            )
          : null,
    );
  }
}

class CoupleWeeklyTrendEntity {
  final int weekIndex;
  final double income;
  final double expense;

  const CoupleWeeklyTrendEntity({
    required this.weekIndex,
    required this.income,
    required this.expense,
  });

  factory CoupleWeeklyTrendEntity.fromJson(Map<String, dynamic> json) {
    return CoupleWeeklyTrendEntity(
      weekIndex: json['weekIndex'] ?? 0,
      income: double.parse(json['income']?.toString() ?? '0'),
      expense: double.parse(json['expense']?.toString() ?? '0'),
    );
  }
}

class CoupleInsightEntity {
  final String title;
  final String message;
  final String severity;
  final String evidence;

  const CoupleInsightEntity({
    required this.title,
    required this.message,
    required this.severity,
    required this.evidence,
  });

  factory CoupleInsightEntity.fromJson(Map<String, dynamic> json) {
    return CoupleInsightEntity(
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'info',
      evidence: json['evidence']?.toString() ?? '',
    );
  }
}

class CoupleSpendingAlertEntity {
  final int id;
  final String type;
  final String severity;
  final String title;
  final String message;
  final int? transactionId;
  final int? categoryId;
  final String? categoryName;
  final String? categoryIcon;
  final double amount;
  final bool isRead;
  final String status;
  final String? feedback;
  final DateTime? createdAt;

  const CoupleSpendingAlertEntity({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    this.transactionId,
    this.categoryId,
    this.categoryName,
    this.categoryIcon,
    required this.amount,
    required this.isRead,
    required this.status,
    this.feedback,
    this.createdAt,
  });

  factory CoupleSpendingAlertEntity.fromJson(Map<String, dynamic> json) {
    return CoupleSpendingAlertEntity(
      id: json['id'] ?? 0,
      type: json['type']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'medium',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      transactionId: json['transactionId'] is int
          ? json['transactionId'] as int
          : int.tryParse(json['transactionId']?.toString() ?? ''),
      categoryId: json['categoryId'] is int
          ? json['categoryId'] as int
          : int.tryParse(json['categoryId']?.toString() ?? ''),
      categoryName: json['categoryName']?.toString(),
      categoryIcon: json['categoryIcon']?.toString(),
      amount: double.parse(json['amount']?.toString() ?? '0'),
      isRead: json['isRead'] == true,
      status: json['status']?.toString() ?? 'open',
      feedback: json['feedback']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class CoupleProfileTopCategory {
  final String name;
  final double average;
  final double percentage;

  const CoupleProfileTopCategory({
    required this.name,
    required this.average,
    required this.percentage,
  });

  factory CoupleProfileTopCategory.fromJson(Map<String, dynamic> json) {
    return CoupleProfileTopCategory(
      name: json['name']?.toString() ?? '',
      average: double.parse(json['average']?.toString() ?? '0'),
      percentage: double.parse(json['percentage']?.toString() ?? '0'),
    );
  }
}

class CoupleProfileEntity {
  final double averageMonthlyIncome;
  final double averageMonthlyExpense;
  final double averageMonthlySavings;
  final List<CoupleProfileTopCategory> topExpenseCategories;
  final List<int> peakSpendingDays;
  final Map<String, double> memberContributionRatio;
  final double spendingConsistencyScore;
  final int activeMonths;

  const CoupleProfileEntity({
    required this.averageMonthlyIncome,
    required this.averageMonthlyExpense,
    required this.averageMonthlySavings,
    required this.topExpenseCategories,
    required this.peakSpendingDays,
    required this.memberContributionRatio,
    required this.spendingConsistencyScore,
    required this.activeMonths,
  });

  factory CoupleProfileEntity.fromJson(Map<String, dynamic> json) {
    final ratioRaw = json['member_contribution_ratio'] as Map? ?? {};
    final ratio = <String, double>{};
    for (final entry in ratioRaw.entries) {
      ratio[entry.key.toString()] =
          double.parse(entry.value?.toString() ?? '0');
    }

    final topCats = (json['top_expense_categories'] as List? ?? [])
        .map((e) => CoupleProfileTopCategory.fromJson(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList();

    final peakDays = (json['peak_spending_days'] as List? ?? [])
        .map((e) => int.parse(e.toString()))
        .toList();

    return CoupleProfileEntity(
      averageMonthlyIncome:
          double.parse(json['average_monthly_income']?.toString() ?? '0'),
      averageMonthlyExpense:
          double.parse(json['average_monthly_expense']?.toString() ?? '0'),
      averageMonthlySavings:
          double.parse(json['average_monthly_savings']?.toString() ?? '0'),
      topExpenseCategories: topCats,
      peakSpendingDays: peakDays,
      memberContributionRatio: ratio,
      spendingConsistencyScore:
          double.parse(json['spending_consistency_score']?.toString() ?? '50'),
      activeMonths: int.parse(json['active_months']?.toString() ?? '0'),
    );
  }
}

class CoupleCategoryForecastEntity {
  final String categoryName;
  final double predictedAmount;
  final double actualAmount;
  final double remainingForecastAmount;
  final double baselineAmount;
  final String trend;
  final double confidence;
  final int dataPoints;

  const CoupleCategoryForecastEntity({
    required this.categoryName,
    required this.predictedAmount,
    required this.actualAmount,
    required this.remainingForecastAmount,
    required this.baselineAmount,
    required this.trend,
    required this.confidence,
    required this.dataPoints,
  });

  factory CoupleCategoryForecastEntity.fromJson(Map<String, dynamic> json) {
    return CoupleCategoryForecastEntity(
      categoryName: json['category_name']?.toString() ?? '',
      predictedAmount:
          double.parse(json['predicted_amount']?.toString() ?? '0'),
      actualAmount: double.parse(json['actual_amount']?.toString() ?? '0'),
      remainingForecastAmount:
          double.parse(json['remaining_forecast_amount']?.toString() ?? '0'),
      baselineAmount:
          double.parse(json['baseline_amount']?.toString() ?? '0'),
      trend: json['trend']?.toString() ?? 'stable',
      confidence: double.parse(json['confidence']?.toString() ?? '0'),
      dataPoints: int.parse(json['data_points']?.toString() ?? '0'),
    );
  }
}

class CoupleForecastEntity {
  final int targetMonth;
  final int targetYear;
  final double totalProjectedExpense;
  final double totalProjectedIncome;
  final double projectedSavings;
  final double actualExpense;
  final double actualIncome;
  final List<CoupleCategoryForecastEntity> categoryForecasts;
  final String method;
  final double confidence;

  const CoupleForecastEntity({
    required this.targetMonth,
    required this.targetYear,
    required this.totalProjectedExpense,
    required this.totalProjectedIncome,
    required this.projectedSavings,
    required this.actualExpense,
    required this.actualIncome,
    required this.categoryForecasts,
    required this.method,
    required this.confidence,
  });

  factory CoupleForecastEntity.fromJson(Map<String, dynamic> json) {
    final catForecasts = (json['category_forecasts'] as List? ?? [])
        .map((e) => CoupleCategoryForecastEntity.fromJson(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList();

    return CoupleForecastEntity(
      targetMonth: int.parse(json['target_month']?.toString() ?? '0'),
      targetYear: int.parse(json['target_year']?.toString() ?? '0'),
      totalProjectedExpense:
          double.parse(json['total_projected_expense']?.toString() ?? '0'),
      totalProjectedIncome:
          double.parse(json['total_projected_income']?.toString() ?? '0'),
      projectedSavings:
          double.parse(json['projected_savings']?.toString() ?? '0'),
      actualExpense:
          double.parse(json['actual_expense']?.toString() ?? '0'),
      actualIncome:
          double.parse(json['actual_income']?.toString() ?? '0'),
      categoryForecasts: catForecasts,
      method: json['method']?.toString() ?? '',
      confidence: double.parse(json['confidence']?.toString() ?? '0'),
    );
  }
}

class CoupleReportEntity {
  final String month;
  final CoupleReportSummaryEntity summary;
  final List<CoupleTopCategoryEntity> topCategories;
  final List<CoupleMemberContributionReportEntity> memberContributions;
  final List<CoupleBudgetProgressReportEntity> budgetProgress;
  final List<CoupleSavingProgressReportEntity> savingProgress;
  final List<CoupleWeeklyTrendEntity> weeklyTrend;
  final List<CoupleInsightEntity> insights;
  final List<CoupleSpendingAlertEntity> alerts;
  final int unreadAlertCount;
  final CoupleProfileEntity? coupleProfile;
  final CoupleForecastEntity? coupleForecast;

  const CoupleReportEntity({
    required this.month,
    required this.summary,
    required this.topCategories,
    required this.memberContributions,
    required this.budgetProgress,
    required this.savingProgress,
    required this.weeklyTrend,
    required this.insights,
    required this.alerts,
    required this.unreadAlertCount,
    this.coupleProfile,
    this.coupleForecast,
  });

  factory CoupleReportEntity.fromJson(Map<String, dynamic> json) {
    List<T> parseList<T>(
      String key,
      T Function(Map<String, dynamic>) fromJson,
    ) {
      final list = json[key] as List<dynamic>? ?? [];
      return list
          .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }

    return CoupleReportEntity(
      month: json['month']?.toString() ?? '',
      summary: CoupleReportSummaryEntity.fromJson(
        Map<String, dynamic>.from(json['summary'] as Map? ?? {}),
      ),
      topCategories: parseList(
        'topCategories',
        CoupleTopCategoryEntity.fromJson,
      ),
      memberContributions: parseList(
        'memberContributions',
        CoupleMemberContributionReportEntity.fromJson,
      ),
      budgetProgress: parseList(
        'budgetProgress',
        CoupleBudgetProgressReportEntity.fromJson,
      ),
      savingProgress: parseList(
        'savingProgress',
        CoupleSavingProgressReportEntity.fromJson,
      ),
      weeklyTrend: parseList('weeklyTrend', CoupleWeeklyTrendEntity.fromJson),
      insights: parseList('insights', CoupleInsightEntity.fromJson),
      alerts: parseList('alerts', CoupleSpendingAlertEntity.fromJson),
      unreadAlertCount: json['unreadAlertCount'] is int
          ? json['unreadAlertCount'] as int
          : int.tryParse(json['unreadAlertCount']?.toString() ?? '0') ?? 0,
      coupleProfile: json['coupleProfile'] != null
          ? CoupleProfileEntity.fromJson(
              Map<String, dynamic>.from(json['coupleProfile'] as Map),
            )
          : null,
      coupleForecast: json['coupleForecast'] != null
          ? CoupleForecastEntity.fromJson(
              Map<String, dynamic>.from(json['coupleForecast'] as Map),
            )
          : null,
    );
  }
}
