class CoupleBudgetEntity {
  final int id;
  final int coupleId;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final double amount;
  final String month;
  final double spentAmount;
  final double remainingAmount;
  final double usagePercentage;

  const CoupleBudgetEntity({
    required this.id,
    required this.coupleId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.amount,
    required this.month,
    required this.spentAmount,
    required this.remainingAmount,
    required this.usagePercentage,
  });
}
