import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class GetGoalPredictionUseCase {
  final SavingGoalRepository repository;

  GetGoalPredictionUseCase(this.repository);

  Future<Either<Failure, GoalAchievementPredictionModel>> call(int id) {
    return repository.getGoalPrediction(id);
  }
}
