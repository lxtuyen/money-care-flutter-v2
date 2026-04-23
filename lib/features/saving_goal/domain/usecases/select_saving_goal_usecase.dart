import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class SelectSavingGoalUseCase {
  final SavingGoalRepository repository;
  SelectSavingGoalUseCase(this.repository);

  Future<Either<Failure, SavingGoalEntity?>> call(
    int userId,
    int SavingGoalId,
  ) {
    return repository.selectSavingGoal(userId, SavingGoalId);
  }
}
