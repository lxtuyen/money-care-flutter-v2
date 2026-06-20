import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/domain/entities/entities.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';

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
  Future<Either<Failure, SpendingPlanStatsEntity?>> getActivePlanStatistics({
    int? month,
    int? year,
    int? startDay,
  });
  Future<Either<Failure, SpendingPlanEntity>> addPlanExpense(
    int planId,
    CreateEstimatedExpenseRequest request,
  );
  Future<Either<Failure, SpendingPlanEntity>> updatePlanExpense(
    int planId,
    int expenseId,
    CreateEstimatedExpenseRequest request,
  );
  Future<Either<Failure, SpendingPlanEntity>> removePlanExpense(
    int planId,
    int expenseId,
  );
}
