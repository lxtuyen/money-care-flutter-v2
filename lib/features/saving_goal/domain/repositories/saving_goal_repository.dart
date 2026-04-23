import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';

abstract class SavingGoalRepository {
  Future<Either<Failure, SavingGoalEntity>> createSavingGoal(SavingGoalDto dto);
  Future<Either<Failure, List<SavingGoalEntity>>> getSavingGoalsByUser(
    int userId,
  );
  Future<Either<Failure, SavingGoalEntity>> getSavingGoal(int id);
  Future<Either<Failure, SavingGoalEntity>> updateSavingGoal(SavingGoalDto dto);
  Future<Either<Failure, bool>> deleteSavingGoal(int id);
  Future<Either<Failure, SavingGoalEntity?>> selectSavingGoal(
    int userId,
    int id,
  );
  Future<Either<Failure, ExpiredGoalCheckModel>> checkExpiredSavingGoal(
    int userId,
  );
  Future<Either<Failure, bool>> markAsNotified(int id);
  Future<Either<Failure, SavingGoalEntity>> extendSavingGoal(
    int id,
    DateTime newEndDate, {
    DateTime? newStartDate,
  });
  Future<Either<Failure, SavingGoalReportModel>> getSavingGoalReport(int id);
}
