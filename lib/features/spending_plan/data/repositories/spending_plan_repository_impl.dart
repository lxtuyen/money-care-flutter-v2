import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/data/datasources/spending_plan_remote_datasource.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
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
  Future<Either<Failure, SpendingPlanEntity>> archivePlan(int id) async {
    try {
      final model = await remoteDatasource.archivePlan(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpendingPlanEntity>> clonePlan(
    int id, {
    int? month,
    int? year,
  }) async {
    try {
      final model = await remoteDatasource.clonePlan(
        id,
        month: month,
        year: year,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
