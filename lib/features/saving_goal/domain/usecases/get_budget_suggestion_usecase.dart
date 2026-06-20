import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class GetBudgetSuggestionUseCase {
  final SavingGoalRepository repository;
  GetBudgetSuggestionUseCase(this.repository);

  Future<Either<Failure, BudgetSuggestionModel>> call({
    double? target,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getBudgetSuggestion(
      target: target,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
