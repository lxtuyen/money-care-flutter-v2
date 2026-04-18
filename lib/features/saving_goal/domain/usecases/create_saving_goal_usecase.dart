import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class CreateSavingGoalUseCase {
  final SavingGoalRepository repository;

  CreateSavingGoalUseCase(this.repository);

  Future<Either<Failure, SavingGoalEntity>> call(SavingGoalDto dto) async {
    return await repository.createSavingGoal(dto);
  }
}
