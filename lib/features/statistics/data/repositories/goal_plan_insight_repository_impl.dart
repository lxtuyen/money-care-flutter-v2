import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/statistics/data/datasources/goal_plan_insight_remote_datasource.dart';
import 'package:money_care/features/statistics/data/models/goal_plan_insight_model.dart';
import 'package:money_care/features/statistics/domain/repositories/goal_plan_insight_repository.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';

class GoalPlanInsightRepositoryImpl implements GoalPlanInsightRepository {
  final GoalPlanInsightRemoteDatasource remoteDatasource;

  const GoalPlanInsightRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, GoalPlanInsightModel>> getInsight(GoalPlanInsightSnapshot snapshot) async {
    try {
      final model = await remoteDatasource.getInsight(snapshot);
      return Right(model);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
