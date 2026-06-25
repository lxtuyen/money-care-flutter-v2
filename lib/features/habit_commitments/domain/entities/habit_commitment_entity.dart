class HabitCommitmentEntity {
  final int id;
  final String habitName;
  final String subcategoryName;
  final int committedCount;
  final int currentCount;
  final int remaining;
  final bool isExceeded;
  final double potentialSavings;
  final double avgPerTransaction;
  final int projectedCount;
  final int? goalId;
  final String? goalName;
  final int month;
  final int year;

  const HabitCommitmentEntity({
    required this.id,
    required this.habitName,
    required this.subcategoryName,
    required this.committedCount,
    this.currentCount = 0,
    this.remaining = 0,
    this.isExceeded = false,
    this.potentialSavings = 0.0,
    this.avgPerTransaction = 0.0,
    this.projectedCount = 0,
    this.goalId,
    this.goalName,
    required this.month,
    required this.year,
  });

  double get progressPercent =>
      committedCount > 0 ? (currentCount / committedCount).clamp(0.0, 1.0) : 0;

  factory HabitCommitmentEntity.fromJson(Map<String, dynamic> json) {
    return HabitCommitmentEntity(
      id: json['id'] as int? ?? 0,
      habitName: json['habitName']?.toString() ?? '',
      subcategoryName: json['subcategoryName']?.toString() ?? '',
      committedCount: json['committedCount'] as int? ?? 0,
      currentCount: json['currentCount'] as int? ?? 0,
      remaining: json['remaining'] as int? ?? 0,
      isExceeded: json['isExceeded'] as bool? ?? false,
      potentialSavings: (json['potentialSavings'] as num?)?.toDouble() ?? 0.0,
      avgPerTransaction: (json['avgPerTransaction'] as num?)?.toDouble() ?? 0.0,
      projectedCount: json['projectedCount'] as int? ?? 0,
      goalId: json['goalId'] as int?,
      goalName: json['goalName']?.toString(),
      month: json['month'] as int? ?? DateTime.now().month,
      year: json['year'] as int? ?? DateTime.now().year,
    );
  }
}

