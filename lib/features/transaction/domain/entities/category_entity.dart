class CategoryEntity {
  final int? id;
  final String name;
  final int percentage;
  final String icon;
  final String? color;

  const CategoryEntity({
    this.id,
    required this.name,
    this.percentage = 0,
    required this.icon,
    this.color,
  });
}
