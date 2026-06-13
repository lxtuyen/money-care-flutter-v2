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

class CoupleSavingProgressReportEntity {
  final int id;
  final String name;
  final double target;
  final double savedAmount;
  final double progress;
  final String status;

  const CoupleSavingProgressReportEntity({
    required this.id,
    required this.name,
    required this.target,
    required this.savedAmount,
    required this.progress,
    required this.status,
  });

  factory CoupleSavingProgressReportEntity.fromJson(Map<String, dynamic> json) {
    return CoupleSavingProgressReportEntity(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      target: double.parse(json['target']?.toString() ?? '0'),
      savedAmount: double.parse(json['savedAmount']?.toString() ?? '0'),
      progress: double.parse(json['progress']?.toString() ?? '0'),
      status: json['status']?.toString() ?? 'active',
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
    );
  }
}
