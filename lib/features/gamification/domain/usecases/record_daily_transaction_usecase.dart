import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/domain/repositories/gamification_repository.dart';

class RecordDailyTransactionUseCase {
  final GamificationRepository repository;
  RecordDailyTransactionUseCase(this.repository);

  Future<Either<Failure, GamificationEntity>> call(
    int userId, {
    DateTime? date,
  }) {
    final today = date ?? DateTime.now();
    return repository.recordDailyTransaction(userId, today);
  }
}
