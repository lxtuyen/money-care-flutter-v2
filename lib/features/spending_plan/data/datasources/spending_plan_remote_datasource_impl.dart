import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/spending_plan/data/datasources/spending_plan_remote_datasource.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';

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
  Future<SpendingPlanModel> addPlanExpense(
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
  Future<SpendingPlanModel> updatePlanExpense(
    int planId,
    int expenseId,
    CreateEstimatedExpenseRequest request,
  ) async {
    final res = await api.patch<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/estimated-expenses/$expenseId',
      body: request.toJson(),
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanModel> removePlanExpense(int planId, int expenseId) async {
    final res = await api.delete<SpendingPlanModel>(
      '${ApiRoutes.spendingPlans}/$planId/estimated-expenses/$expenseId',
      fromJsonT: (json) => SpendingPlanModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SpendingPlanStatsModel?> getActivePlanStatistics({
    int? month,
    int? year,
    int? startDay,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (month != null) queryParams['month'] = month.toString();
    if (year != null) queryParams['year'] = year.toString();
    if (startDay != null) queryParams['startDay'] = startDay.toString();

    final res = await api.get<SpendingPlanStatsModel?>(
      '${ApiRoutes.spendingPlans}/active/statistics',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJsonT: (json) =>
          json == null ? null : SpendingPlanStatsModel.fromJson(json),
    );
    return res.unwrap();
  }
}
