import 'package:money_care/features/gamification/data/models/badge_model.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';

/// Data model cho GamificationEntity — Requirements: 8.1, 10.5
class GamificationModel {
  final int userId;
  final int currentStreak;
  final DateTime? lastTransactionDate;
  final List<BadgeModel> badges;

  const GamificationModel({
    required this.userId,
    required this.currentStreak,
    this.lastTransactionDate,
    required this.badges,
  });

  factory GamificationModel.fromJson(Map<String, dynamic> json) {
    return GamificationModel(
      userId: json['userId'] as int,
      currentStreak: (json['currentStreak'] as int?) ?? 0,
      lastTransactionDate: json['lastTransactionDate'] != null
          ? DateTime.parse(json['lastTransactionDate'] as String)
          : null,
      badges: (json['badges'] as List<dynamic>? ?? [])
          .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'currentStreak': currentStreak,
        'lastTransactionDate': lastTransactionDate?.toIso8601String(),
        'badges': badges.map((b) => b.toJson()).toList(),
      };

  factory GamificationModel.fromEntity(GamificationEntity entity) {
    return GamificationModel(
      userId: entity.userId,
      currentStreak: entity.currentStreak,
      lastTransactionDate: entity.lastTransactionDate,
      badges: entity.badges.map((b) => BadgeModel.fromEntity(b)).toList(),
    );
  }

  GamificationEntity toEntity() => GamificationEntity(
        userId: userId,
        currentStreak: currentStreak,
        lastTransactionDate: lastTransactionDate,
        badges: badges.map((b) => b.toEntity()).toList(),
      );
}
