class FixedExpenseEntity {
  final int id;
  final String name;
  final String? category;
  final double amount;
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
    required this.amount,
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
  final int month;
  final int year;
  final double totalAmount;
  final double savingTargetAmount;
  final double fixedExpenseTotal;
  final double availableSpendingAmount;
  final String status;
  final String riskLevel;
  final List<FixedExpenseEntity> fixedExpenses;

  const SpendingPlanEntity({
    required this.id,
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.savingTargetAmount,
    required this.fixedExpenseTotal,
    required this.availableSpendingAmount,
    required this.status,
    required this.riskLevel,
    required this.fixedExpenses,
  });

  bool get isActive => status == 'active';
  bool get isArchived => status == 'archived';
}
