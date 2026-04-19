import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class GetSavingGoalReportUseCase {
  final SavingGoalRepository repository;

  GetSavingGoalReportUseCase(this.repository);

  Future<Either<Failure, SavingGoalReportModel>> call(int id) async {
    return await repository.getSavingGoalReport(id);
  }
}
