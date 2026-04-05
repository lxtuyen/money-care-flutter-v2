class FundEntity {
  final int id;
  final String name;
  final bool? isSelected;

  const FundEntity({
    required this.id,
    required this.name,
    this.isSelected,
  });
}
