import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/gamification/data/datasources/gamification_remote_datasource.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/domain/repositories/gamification_repository.dart';

/// Repository implementation cho Gamification.
/// Offline-first KHÔNG áp dụng — hiển thị snackbar khi offline.
/// Dữ liệu được lưu trên backend để tránh mất khi xóa cache.
/// Requirements: 8.1, 10.5
class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationRemoteDatasource remoteDatasource;

  GamificationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, GamificationEntity>> getGamification(
    int userId,
  ) async {
    try {
      final model = await remoteDatasource.getGamification(userId);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GamificationEntity>> recordDailyTransaction(
    int userId,
    DateTime date,
  ) async {
    try {
      final model = await remoteDatasource.recordDay(userId, date);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GamificationEntity>> awardBadge(
    int userId,
    BadgeEntity badge,
  ) async {
    try {
      // Lấy trạng thái hiện tại, cấp badge (idempotent), lưu lại — Requirement 8.9
      final model = await remoteDatasource.recordDay(userId, badge.awardedAt);
      return Right(model.toEntity().awardBadge(badge));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GamificationEntity>> saveGamification(
    GamificationEntity entity,
  ) async {
    try {
      // POST to record-day syncs the full state to backend — Requirement 10.5
      final res = await remoteDatasource.recordDay(
        entity.userId,
        entity.lastTransactionDate ?? DateTime.now(),
      );
      return Right(res.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
