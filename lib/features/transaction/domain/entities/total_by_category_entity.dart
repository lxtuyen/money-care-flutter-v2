class TotalByCategoryEntity {
  final int? categoryId;
  final String categoryName;
  final int total;
  final double percentage;
  final double spendingPercentage;
  final double limit;
  final String categoryIcon;
  final bool isEssential;
  final String? color;

  const TotalByCategoryEntity({
    this.categoryId,
    required this.categoryName,
    required this.total,
    this.percentage = 0,
    this.spendingPercentage = 0,
    this.limit = 0,
    required this.categoryIcon,
    this.isEssential = true,
    this.color,
  });
}
