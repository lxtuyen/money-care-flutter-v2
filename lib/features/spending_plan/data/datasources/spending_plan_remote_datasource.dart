import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';

abstract class SpendingPlanRemoteDatasource {
  Future<List<SpendingPlanModel>> getPlans();
  Future<SpendingPlanModel?> getActivePlan();
  Future<SpendingPlanModel> getPlan(int id);
  Future<SpendingPlanModel> createPlan(CreateSpendingPlanRequest request);
  Future<SpendingPlanModel> updatePlan(
    int id,
    UpdateSpendingPlanRequest request,
  );
  Future<void> deletePlan(int id);
  Future<SpendingPlanModel> activatePlan(int id);
  Future<SpendingPlanModel> pausePlan(int id);
  Future<SpendingPlanModel> addPlanExpense(
    int planId,
    CreateEstimatedExpenseRequest request,
  );
  Future<SpendingPlanModel> updatePlanExpense(
    int planId,
    int expenseId,
    CreateEstimatedExpenseRequest request,
  );
  Future<SpendingPlanModel> removePlanExpense(int planId, int expenseId);
  Future<SpendingPlanStatsModel?> getActivePlanStatistics({
    int? month,
    int? year,
    int? startDay,
  });
}
