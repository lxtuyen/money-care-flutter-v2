import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class SavingGoalEntity {
  final int id;
  final String name;
  final bool? isSelected;
  final List<CategoryEntity> categories;

  final double? target;

  final double savedAmount;

  final bool isCompleted;

  final String? templateKey;

  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? updatedAt;
  final String? status;

  const SavingGoalEntity({
    required this.id,
    required this.name,
    this.isSelected,
    this.categories = const [],
    this.target,
    this.savedAmount = 0,
    this.isCompleted = false,
    this.templateKey,
    this.startDate,
    this.endDate,
    this.updatedAt,
    this.status,
  });

  double get progressPercent {
    final t = target ?? 0;
    if (t <= 0) return 0;
    final p = (savedAmount / t) * 100;
    return p > 100 ? 100 : p;
  }

  int get monthlySavingsNeeded {
    if (endDate == null || target == null) return 0;
    final now = DateTime.now();
    if (endDate!.isBefore(now) || isCompleted) return 0;
    final remaining = (target ?? 0) - savedAmount;
    if (remaining <= 0) return 0;
    final months =
        (endDate!.year - now.year) * 12 + (endDate!.month - now.month);
    if (months <= 0) return remaining.ceil();
    return (remaining / months).ceil();
  }

  bool get isExpired {
    if (endDate == null) return false;
    return endDate!.isBefore(DateTime.now());
  }

  int get daysSinceExpired {
    if (!isExpired || endDate == null) return 0;
    return DateTime.now().difference(endDate!).inDays;
  }
}
