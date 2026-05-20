import 'package:money_care/features/statistics/data/datasources/goal_plan_insight_remote_datasource.dart';
import 'package:money_care/features/statistics/data/models/goal_plan_insight_model.dart';
import 'package:money_care/features/statistics/domain/repositories/goal_plan_insight_repository.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';

class GoalPlanInsightRepositoryImpl implements GoalPlanInsightRepository {
  final GoalPlanInsightRemoteDatasource remoteDatasource;

  const GoalPlanInsightRepositoryImpl({required this.remoteDatasource});

  @override
  Future<GoalPlanInsightModel> getInsight(GoalPlanInsightSnapshot snapshot) {
    return remoteDatasource.getInsight(snapshot);
  }
}
