import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/domain/repositories/gamification_repository.dart';

/// Ghi nhận giao dịch đầu tiên trong ngày và cập nhật streak
/// Requirements: 8.1, 8.2, 8.3
class RecordDailyTransactionUseCase {
  final GamificationRepository repository;
  RecordDailyTransactionUseCase(this.repository);

  /// Ghi nhận giao dịch cho [userId] vào ngày [date] (mặc định hôm nay).
  /// Nếu đã ghi trong ngày, streak không thay đổi.
  /// Nếu bỏ ngày, streak reset về 1.
  Future<Either<Failure, GamificationEntity>> call(
    int userId, {
    DateTime? date,
  }) {
    final today = date ?? DateTime.now();
    return repository.recordDailyTransaction(userId, today);
  }
}
