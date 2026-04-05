import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';

abstract class GamificationRepository {
  /// Lấy trạng thái gamification của người dùng — Requirement 8.1, 8.8
  Future<Either<Failure, GamificationEntity>> getGamification(int userId);

  /// Ghi nhận giao dịch trong ngày và cập nhật streak — Requirement 8.2
  Future<Either<Failure, GamificationEntity>> recordDailyTransaction(int userId, DateTime date);

  /// Cấp badge cho người dùng (idempotent) — Requirement 8.9
  Future<Either<Failure, GamificationEntity>> awardBadge(int userId, BadgeEntity badge);

  /// Lưu toàn bộ trạng thái gamification — Requirement 10.5
  Future<Either<Failure, GamificationEntity>> saveGamification(GamificationEntity entity);
}
