import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';

class WalletEntity {
  final int id;
  final String name;
  final double balance;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SavingGoalEntity> savingGoals;

  const WalletEntity({
    required this.id,
    required this.name,
    required this.balance,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.savingGoals = const [],
  });

  factory WalletEntity.fromJson(Map<String, dynamic> json) {
    return WalletEntity(
      id: json['id'],
      name: json['name'],
      balance: double.parse(json['balance']?.toString() ?? '0'),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      savingGoals: json['savingGoals'] != null
          ? (json['savingGoals'] as List)
                .map<SavingGoalEntity>(
                  (e) => SavingGoalEntity.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'is_active': isActive,
      'savingGoals': savingGoals.map((e) => e.toJson()).toList(),
    };
  }
}
