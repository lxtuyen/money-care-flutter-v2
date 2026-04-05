import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/domain/repositories/gamification_repository.dart';

/// Kiểm tra điều kiện và cấp badge nếu đủ điều kiện (idempotent)
/// Requirements: 8.4, 8.5, 8.6, 8.9
class CheckAndAwardBadgesUseCase {
  final GamificationRepository repository;
  CheckAndAwardBadgesUseCase(this.repository);

  /// Kiểm tra streak và cấp badge tương ứng.
  /// [goalCompleted] = true khi một Goal_Fund đạt 100% — Requirement 8.6
  Future<Either<Failure, GamificationEntity>> call(
    GamificationEntity current, {
    bool goalCompleted = false,
  }) async {
    var entity = current;

    // Requirement 8.4: Badge "Tiết kiệm 7 ngày" khi streak >= 7
    if (entity.currentStreak >= 7 && !entity.hasBadge(BadgeKeys.streak7)) {
      final badge = BadgeEntity(
        key: BadgeKeys.streak7,
        name: BadgeNames.streak7,
        awardedAt: DateTime.now(),
      );
      final result = await repository.awardBadge(entity.userId, badge);
      result.fold((_) {}, (updated) => entity = updated);
    }

    // Requirement 8.5: Badge "Tiết kiệm 30 ngày" khi streak >= 30
    if (entity.currentStreak >= 30 && !entity.hasBadge(BadgeKeys.streak30)) {
      final badge = BadgeEntity(
        key: BadgeKeys.streak30,
        name: BadgeNames.streak30,
        awardedAt: DateTime.now(),
      );
      final result = await repository.awardBadge(entity.userId, badge);
      result.fold((_) {}, (updated) => entity = updated);
    }

    // Requirement 8.6: Badge "Mục tiêu hoàn thành" khi Goal_Fund đạt 100%
    if (goalCompleted && !entity.hasBadge(BadgeKeys.goalCompleted)) {
      final badge = BadgeEntity(
        key: BadgeKeys.goalCompleted,
        name: BadgeNames.goalCompleted,
        awardedAt: DateTime.now(),
      );
      final result = await repository.awardBadge(entity.userId, badge);
      result.fold((_) {}, (updated) => entity = updated);
    }

    return Right(entity);
  }
}
