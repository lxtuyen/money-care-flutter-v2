enum FinanceMode { normal, saving, survival }

class FinanceModeEntity {
  final int userId;
  final FinanceMode mode;
  final DateTime updatedAt;
  final DateTime? suggestionCooldownUntil;

  const FinanceModeEntity({
    required this.userId,
    required this.mode,
    required this.updatedAt,
    this.suggestionCooldownUntil,
  });
}
