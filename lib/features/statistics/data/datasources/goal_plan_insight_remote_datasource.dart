import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/statistics/data/models/goal_plan_insight_model.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';

abstract class GoalPlanInsightRemoteDatasource {
  Future<GoalPlanInsightModel> getInsight(GoalPlanInsightSnapshot snapshot);
}

class GoalPlanInsightRemoteDatasourceImpl
    implements GoalPlanInsightRemoteDatasource {
  final ApiClient api;

  const GoalPlanInsightRemoteDatasourceImpl({required this.api});

  @override
  Future<GoalPlanInsightModel> getInsight(
    GoalPlanInsightSnapshot snapshot,
  ) async {
    final res = await api.post<GoalPlanInsightModel>(
      ApiRoutes.goalPlanInsight,
      body: snapshot.toJson(),
      fromJsonT: (json) =>
          GoalPlanInsightModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }
}
