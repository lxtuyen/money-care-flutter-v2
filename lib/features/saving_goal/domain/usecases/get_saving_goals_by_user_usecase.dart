import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class GetSavingGoalsByUserUseCase {
  final SavingGoalRepository repository;
  GetSavingGoalsByUserUseCase(this.repository);

  Future<Either<Failure, List<SavingGoalEntity>>> call(int userId) {
    return repository.getSavingGoalsByUser(userId);
  }
}
