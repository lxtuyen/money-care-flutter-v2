import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/statistics/data/models/goal_plan_insight_model.dart';
import 'package:money_care/features/statistics/domain/repositories/goal_plan_insight_repository.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';

class GetGoalPlanInsightUseCase {
  final GoalPlanInsightRepository repository;

  const GetGoalPlanInsightUseCase(this.repository);

  Future<Either<Failure, GoalPlanInsightModel>> call(GoalPlanInsightSnapshot snapshot) {
    return repository.getInsight(snapshot);
  }
}
