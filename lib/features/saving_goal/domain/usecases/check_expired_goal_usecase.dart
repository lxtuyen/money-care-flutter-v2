import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class CheckExpiredSavingGoalUseCase {
  final SavingGoalRepository repository;
  CheckExpiredSavingGoalUseCase(this.repository);

  Future<Either<Failure, ExpiredGoalCheckModel>> call(int userId) {
    return repository.checkExpiredSavingGoal(userId);
  }
}
