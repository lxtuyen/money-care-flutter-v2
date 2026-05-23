import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';

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
  Future<SpendingPlanModel> createEstimatedExpense(
    int planId,
    CreateEstimatedExpenseRequest request,
  );
  Future<SpendingPlanModel> updateEstimatedExpense(
    int planId,
    int expenseId,
    Map<String, dynamic> data,
  );
  Future<SpendingPlanModel> deleteEstimatedExpense(int planId, int expenseId);
  Future<SpendingPlanStatsModel?> getActivePlanStatistics();
}

class SpendingPlanRemoteDatasourceImpl implements SpendingPlanRemoteDatasource {
  final ApiClient api;

  SpendingPlanRemoteDatasourceImpl({required this.api});

  @override
  Future<List<SpendingPlanModel>> getPlans() async {
    final res = await api.get<List<SpendingPlanModel>>(
      ApiRoutes.spendingPlans,
      fromJsonT: (json) {
        final list = json as List;
        return list.map((item) => SpendingPlanModel.fromJson(item)).toList();
      },
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel?> getActivePlan() async {
    final res = await api.get<SpendingPlanModel?>(
      '${ApiRoutes.spendingPlans}/active',
      fromJsonT: (json) =>
          json == null ? null : SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> getPlan(int id) async {
    final res = await api.get<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> createPlan(
    CreateSpendingPlanRequest request,
  ) async {
    final res = await api.post<SpendingPlanModel>(
      ApiRoutes.spendingPlans,
      body: request.toJson(),
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> updatePlan(
    int id,
    UpdateSpendingPlanRequest request,
  ) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id',
      body: request.toJson(),
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<void> deletePlan(int id) async {
    final res = await api.delete<dynamic>('${ApiRoutes.spendingPlans}/$id');
    res.unwrap();
  }

  @override
  Future<SpendingPlanModel> activatePlan(int id) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id/activate',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> pausePlan(int id) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$id/pause',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> createEstimatedExpense(
    int planId,
    CreateEstimatedExpenseRequest request,
  ) async {
    final res = await api.post<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/estimated-expenses',
      body: request.toJson(),
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> updateEstimatedExpense(
    int planId,
    int expenseId,
    Map<String, dynamic> data,
  ) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/estimated-expenses/$expenseId',
      body: data,
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> deleteEstimatedExpense(
    int planId,
    int expenseId,
  ) async {
    final res = await api.delete<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/estimated-expenses/$expenseId',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanStatsModel?> getActivePlanStatistics() async {
    final res = await api.get<SpendingPlanStatsModel?>(
      '${ApiRoutes.spendingPlans}/active/statistics',
      fromJsonT: (json) =>
          json == null ? null : SpendingPlanStatsModel.fromJson(json),
    );
    return res.unwrap();
  }
}
