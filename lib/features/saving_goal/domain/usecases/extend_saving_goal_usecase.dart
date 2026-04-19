import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class ExtendSavingGoalUseCase {
  final SavingGoalRepository repository;
  ExtendSavingGoalUseCase(this.repository);

  Future<Either<Failure, dynamic>> call(
    int savingGoalId,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) {
    return repository.extendSavingGoal(savingGoalId, newEndDate, newStartDate: newStartDate);
  }
}
