import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class DeleteSavingGoalUseCase {
  final SavingGoalRepository repository;
  DeleteSavingGoalUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteSavingGoal(id);
  }
}
