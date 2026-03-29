class TotalByTypeEntity {
  final int incomeTotal;
  final int expenseTotal;
  final int currentSaving;
  final int targetSaving;

  const TotalByTypeEntity({
    required this.incomeTotal,
    required this.expenseTotal,
    this.currentSaving = 0,
    this.targetSaving = 0,
  });
}
