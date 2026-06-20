import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class PauseSavingGoalUseCase {
  final SavingGoalRepository repository;

  PauseSavingGoalUseCase(this.repository);

  Future<Either<Failure, SavingGoalEntity>> call(int goalId) async {
    return await repository.pauseGoal(goalId);
  }
}
