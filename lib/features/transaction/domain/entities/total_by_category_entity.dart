class TotalByCategoryEntity {
  final int? categoryId;
  final String categoryName;
  final int total;
  final double spendingPercentage;
  final String categoryIcon;
  final bool isEssential;
  final String? color;

  const TotalByCategoryEntity({
    this.categoryId,
    required this.categoryName,
    required this.total,
    this.spendingPercentage = 0,
    required this.categoryIcon,
    this.isEssential = true,
    this.color,
  });
}
