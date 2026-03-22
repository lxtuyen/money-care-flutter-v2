class SavingFundEntity {
  final int id;
  final String name;
  final bool? isSelected;

  const SavingFundEntity({
    required this.id,
    required this.name,
    this.isSelected,
  });
}
