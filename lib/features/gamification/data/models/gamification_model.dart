import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/gamification/data/models/badge_model.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';

part 'gamification_model.freezed.dart';
part 'gamification_model.g.dart';

@freezed
class GamificationModel with _$GamificationModel {
  const factory GamificationModel({
    required int userId,
    @Default(0) int currentStreak,
    DateTime? lastTransactionDate,
    @Default([]) List<BadgeModel> badges,
  }) = _GamificationModel;

  const GamificationModel._();

  factory GamificationModel.fromJson(Map<String, dynamic> json) =>
      _$GamificationModelFromJson(json);

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
