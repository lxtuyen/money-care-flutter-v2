import 'package:money_care/features/statistics/data/models/goal_plan_insight_model.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';

abstract class GoalPlanInsightRepository {
  Future<GoalPlanInsightModel> getInsight(GoalPlanInsightSnapshot snapshot);
}
