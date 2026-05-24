import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/domain/entities/entities.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class GetActiveSpendingPlanStatisticsUseCase {
  final SpendingPlanRepository repository;

  GetActiveSpendingPlanStatisticsUseCase(this.repository);

  Future<Either<Failure, SpendingPlanStatsEntity?>> call() =>
      repository.getActivePlanStatistics();
}
