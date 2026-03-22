class TotalByCategoryEntity {
  final String categoryName;
  final int total;
  final int percentage;
  final String categoryIcon;
  final String? color;

  const TotalByCategoryEntity({
    required this.categoryName,
    required this.total,
    this.percentage = 0,
    required this.categoryIcon,
    this.color,
  });
}
