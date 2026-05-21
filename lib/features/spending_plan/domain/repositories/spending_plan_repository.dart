import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';

abstract class SpendingPlanRepository {
  Future<Either<Failure, List<SpendingPlanEntity>>> getPlans();
  Future<Either<Failure, SpendingPlanEntity?>> getActivePlan();
  Future<Either<Failure, SpendingPlanEntity>> getPlan(int id);
  Future<Either<Failure, SpendingPlanEntity>> createPlan(
    CreateSpendingPlanRequest request,
  );
  Future<Either<Failure, SpendingPlanEntity>> updatePlan(
    int id,
    UpdateSpendingPlanRequest request,
  );
  Future<Either<Failure, Unit>> deletePlan(int id);
  Future<Either<Failure, SpendingPlanEntity>> activatePlan(int id);
  Future<Either<Failure, SpendingPlanEntity>> pausePlan(int id);
  Future<Either<Failure, SpendingPlanEntity>> archivePlan(int id);
  Future<Either<Failure, SpendingPlanStatsEntity?>> getActivePlanStatistics();
}
