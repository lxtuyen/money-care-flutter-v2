import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';

class SavingGoalEntity {
  final int id;
  final String name;
  final bool? isSelected;
  final List<CategoryEntity> categories;
  final WalletEntity? wallet;

  final double? target;

  final double savedAmount;

  final bool isCompleted;

  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? updatedAt;
  final String? status;

  final bool isBudgetEnabled;

  const SavingGoalEntity({
    required this.id,
    required this.name,
    this.isSelected,
    this.categories = const [],
    this.target,
    this.savedAmount = 0,
    this.isCompleted = false,
    this.isBudgetEnabled = false,

    this.startDate,
    this.endDate,
    this.updatedAt,
    this.status,
    this.wallet,
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
        (endDate!.year - now.year) * 12 + (endDate!.month - now.month) + 1;
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

  bool get isPaused => status == 'PAUSED';
  bool get isActive => status == 'ACTIVE' && !isCompleted && !isExpired;

  factory SavingGoalEntity.fromJson(Map<String, dynamic> json) {
    return SavingGoalEntity(
      id: json['id'],
      name: json['name'],
      target: double.tryParse(json['target']?.toString() ?? '0'),
      savedAmount:
          double.tryParse(json['saved_amount']?.toString() ?? '0') ?? 0,
      isCompleted: json['is_completed'] ?? false,
      isBudgetEnabled: json['is_budget_enabled'] ?? false,
      status: json['status'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      wallet: json['wallet'] != null
          ? WalletEntity.fromJson(json['wallet'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'target': target,
      'saved_amount': savedAmount,
      'is_completed': isCompleted,
      'is_budget_enabled': isBudgetEnabled,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}
