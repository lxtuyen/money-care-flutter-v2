class EstimatedExpenseEntity {
  final int id;
  final String? category;
  final int? categoryId;
  final String? subCategory;
  final int? subCategoryId;
  final double amount;
  final double monthlyLimit;
  final double? dailyLimit;
  final double spentThisMonth;
  final double todaySpent;
  final double monthlyProgress;
  final double dailyOverAmount;
  final String frequencyType;
  final int frequencyValue;

  const EstimatedExpenseEntity({
    required this.id,
    this.category,
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    required this.amount,
    this.monthlyLimit = 0,
    this.dailyLimit,
    this.spentThisMonth = 0,
    this.todaySpent = 0,
    this.monthlyProgress = 0,
    this.dailyOverAmount = 0,
    required this.frequencyType,
    required this.frequencyValue,
  });

  String get displayName {
    final subCategoryName = subCategory?.trim();
    if (subCategoryName != null && subCategoryName.isNotEmpty) {
      return subCategoryName;
    }
    final categoryName = category?.trim();
    if (categoryName != null && categoryName.isNotEmpty) {
      return categoryName;
    }
    return 'Khoản chi dự kiến';
  }
}

class SpendingPlanEntity {
  final int id;
  final double totalAmount;
  final double savingTargetAmount;
  final double estimatedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<EstimatedExpenseEntity> estimatedExpenses;

  const SpendingPlanEntity({
    required this.id,
    required this.totalAmount,
    required this.savingTargetAmount,
    required this.estimatedExpenseTotal,
    required this.availableSpendingAmount,
    required this.status,
    required this.riskLevel,
    required this.estimatedExpenses,
  });

  bool get isActive => status == 'active';
  bool get isPaused => status == 'paused';
  bool get isArchived => status == 'archived';
  int get month => DateTime.now().month;
  int get year => DateTime.now().year;

  SpendingPlanEntity copyWith({
    int? id,
    double? totalAmount,
    double? savingTargetAmount,
    double? estimatedExpenseTotal,
    double? availableSpendingAmount,
    String? status,
    String? riskLevel,
    List<EstimatedExpenseEntity>? estimatedExpenses,
  }) {
    return SpendingPlanEntity(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,
      savingTargetAmount: savingTargetAmount ?? this.savingTargetAmount,
      estimatedExpenseTotal:
          estimatedExpenseTotal ?? this.estimatedExpenseTotal,
      availableSpendingAmount:
          availableSpendingAmount ?? this.availableSpendingAmount,
      status: status ?? this.status,
      riskLevel: riskLevel ?? this.riskLevel,
      estimatedExpenses: estimatedExpenses ?? this.estimatedExpenses,
    );
  }
}

class SpendingPlanStatsEntity {
  final int planId;
  final String planName;
  final double availableSpendingAmount;
  final double spentFlexibleAmount;
  final double spentEstimatedAmount;
  final double remainingAmount;
  final int daysLeft;
  final double projectedEndBalance;
  final List<EstimatedExpenseEntity> estimatedExpenses;

  const SpendingPlanStatsEntity({
    required this.planId,
    required this.planName,
    required this.availableSpendingAmount,
    required this.spentFlexibleAmount,
    required this.spentEstimatedAmount,
    required this.remainingAmount,
    required this.daysLeft,
    required this.projectedEndBalance,
    required this.estimatedExpenses,
  });
}
