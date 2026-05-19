import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class GetSpendingPlansUseCase {
  final SpendingPlanRepository repository;

  GetSpendingPlansUseCase(this.repository);

  Future<Either<Failure, List<SpendingPlanEntity>>> call() =>
      repository.getPlans();
}

class GetActiveSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  GetActiveSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity?>> call() =>
      repository.getActivePlan();
}

class GetSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  GetSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(int id) =>
      repository.getPlan(id);
}

class CreateSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  CreateSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(
    CreateSpendingPlanRequest request,
  ) => repository.createPlan(request);
}

class UpdateSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  UpdateSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(
    int id,
    UpdateSpendingPlanRequest request,
  ) => repository.updatePlan(id, request);
}

class DeleteSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  DeleteSpendingPlanUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) => repository.deletePlan(id);
}

class ActivateSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  ActivateSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(int id) =>
      repository.activatePlan(id);
}

class PauseSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  PauseSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(int id) =>
      repository.pausePlan(id);
}

class ArchiveSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  ArchiveSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(int id) =>
      repository.archivePlan(id);
}

class GetActiveSpendingPlanStatisticsUseCase {
  final SpendingPlanRepository repository;

  GetActiveSpendingPlanStatisticsUseCase(this.repository);

  Future<Either<Failure, SpendingPlanStatsEntity?>> call() =>
      repository.getActivePlanStatistics();
}
