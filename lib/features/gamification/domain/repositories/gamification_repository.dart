import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';

abstract class GamificationRepository {
  Future<Either<Failure, GamificationEntity>> getGamification(int userId);

  Future<Either<Failure, GamificationEntity>> recordDailyTransaction(int userId, DateTime date);

  Future<Either<Failure, GamificationEntity>> awardBadge(int userId, BadgeEntity badge);

  Future<Either<Failure, GamificationEntity>> saveGamification(GamificationEntity entity);
}
