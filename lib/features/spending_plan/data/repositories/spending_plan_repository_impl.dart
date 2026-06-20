import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/data/datasources/spending_plan_remote_datasource.dart';
import 'package:money_care/features/spending_plan/domain/entities/entities.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class SpendingPlanRepositoryImpl implements SpendingPlanRepository {
  final SpendingPlanRemoteDatasource remoteDatasource;

  SpendingPlanRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<SpendingPlanEntity>>> getPlans() async {
    try {
      final models = await remoteDatasource.getPlans();
      return Right(models.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity?>> getActivePlan() async {
    try {
      final model = await remoteDatasource.getActivePlan();
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> getPlan(int id) async {
    try {
      final model = await remoteDatasource.getPlan(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> createPlan(
    CreateSpendingPlanRequest request,
  ) async {
    try {
      final model = await remoteDatasource.createPlan(request);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> updatePlan(
    int id,
    UpdateSpendingPlanRequest request,
  ) async {
    try {
      final model = await remoteDatasource.updatePlan(id, request);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePlan(int id) async {
    try {
      await remoteDatasource.deletePlan(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> activatePlan(int id) async {
    try {
      final model = await remoteDatasource.activatePlan(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> pausePlan(int id) async {
    try {
      final model = await remoteDatasource.pausePlan(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanStatsEntity?>>
  getActivePlanStatistics({
    int? month,
    int? year,
    int? startDay,
  }) async {
    try {
      final model = await remoteDatasource.getActivePlanStatistics(
        month: month,
        year: year,
        startDay: startDay,
      );
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> addPlanExpense(
    int planId,
    CreateEstimatedExpenseRequest request,
  ) async {
    try {
      final model = await remoteDatasource.addPlanExpense(planId, request);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> updatePlanExpense(
    int planId,
    int expenseId,
    CreateEstimatedExpenseRequest request,
  ) async {
    try {
      final model = await remoteDatasource.updatePlanExpense(
        planId,
        expenseId,
        request,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> removePlanExpense(
    int planId,
    int expenseId,
  ) async {
    try {
      final model = await remoteDatasource.removePlanExpense(planId, expenseId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
