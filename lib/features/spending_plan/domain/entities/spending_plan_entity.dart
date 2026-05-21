class FixedExpenseEntity {
  final int id;
  final String name;
  final String? category;
  final int? categoryId;
  final String? subCategory;
  final int? subCategoryId;
  final String trackingType;
  final double amount;
  final double monthlyLimit;
  final double? dailyLimit;
  final double spentThisMonth;
  final double todaySpent;
  final double monthlyProgress;
  final double dailyOverAmount;
  final String frequencyType;
  final int frequencyValue;
  final int? dueDay;
  final String? note;
  final bool isPaid;
  final bool isReminderEnabled;
  final int? linkedTransactionId;

  const FixedExpenseEntity({
    required this.id,
    required this.name,
    this.category,
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    this.trackingType = 'fixed_bill',
    required this.amount,
    this.monthlyLimit = 0,
    this.dailyLimit,
    this.spentThisMonth = 0,
    this.todaySpent = 0,
    this.monthlyProgress = 0,
    this.dailyOverAmount = 0,
    required this.frequencyType,
    required this.frequencyValue,
    this.dueDay,
    this.note,
    required this.isPaid,
    required this.isReminderEnabled,
    this.linkedTransactionId,
  });
}

class SpendingPlanEntity {
  final int id;
  final double totalAmount;
  final double savingTargetAmount;
  final double fixedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<FixedExpenseEntity> fixedExpenses;

  const SpendingPlanEntity({
    required this.id,
    required this.totalAmount,
    required this.savingTargetAmount,
    required this.fixedExpenseTotal,
    required this.availableSpendingAmount,
    required this.status,
    required this.riskLevel,
    required this.fixedExpenses,
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
    double? fixedExpenseTotal,
    double? availableSpendingAmount,
    String? status,
    String? riskLevel,
    List<FixedExpenseEntity>? fixedExpenses,
  }) {
    return SpendingPlanEntity(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,
      savingTargetAmount: savingTargetAmount ?? this.savingTargetAmount,
      fixedExpenseTotal: fixedExpenseTotal ?? this.fixedExpenseTotal,
      availableSpendingAmount:
          availableSpendingAmount ?? this.availableSpendingAmount,
      status: status ?? this.status,
      riskLevel: riskLevel ?? this.riskLevel,
      fixedExpenses: fixedExpenses ?? this.fixedExpenses,
    );
  }
}

class SpendingPlanStatsEntity {
  final int planId;
  final String planName;
  final double availableSpendingAmount;
  final double spentFlexibleAmount;
  final double spentFixedAmount;
  final double remainingAmount;
  final int daysLeft;
  final double projectedEndBalance;
  final List<FixedExpenseEntity> fixedExpenses;

  const SpendingPlanStatsEntity({
    required this.planId,
    required this.planName,
    required this.availableSpendingAmount,
    required this.spentFlexibleAmount,
    required this.spentFixedAmount,
    required this.remainingAmount,
    required this.daysLeft,
    required this.projectedEndBalance,
    required this.fixedExpenses,
  });
}
