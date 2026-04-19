import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class MarkAsNotifiedUseCase {
  final SavingGoalRepository repository;
  MarkAsNotifiedUseCase(this.repository);

  Future<Either<Failure, bool>> call(int savingGoalId) {
    return repository.markAsNotified(savingGoalId);
  }
}
