import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/domain/repositories/gamification_repository.dart';

class GetGamificationUseCase {
  final GamificationRepository repository;
  GetGamificationUseCase(this.repository);

  Future<Either<Failure, GamificationEntity>> call(int userId) {
    return repository.getGamification(userId);
  }
}
