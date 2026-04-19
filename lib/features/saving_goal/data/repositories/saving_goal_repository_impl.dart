import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_goal/data/datasources/saving_goal_remote_datasource.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/repositories/saving_goal_repository.dart';

class SavingGoalRepositoryImpl implements SavingGoalRepository {
  final SavingGoalRemoteDatasource remoteDatasource;

  SavingGoalRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, SavingGoalEntity>> createSavingGoal(SavingGoalDto dto) async {
    try {
      final model = await remoteDatasource.createSavingGoal(dto);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavingGoalEntity>>> getSavingGoalsByUser(int userId) async {
    try {
      final models = await remoteDatasource.getSavingGoalsByUser(userId);
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingGoalEntity>> getSavingGoal(int id) async {
    try {
      final model = await remoteDatasource.getSavingGoal(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingGoalEntity>> updateSavingGoal(SavingGoalDto dto) async {
    try {
      final model = await remoteDatasource.updateSavingGoal(dto);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSavingGoal(int id) async {
    try {
      final res = await remoteDatasource.deleteSavingGoal(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingGoalEntity?>> selectSavingGoal(int userId, int id) async {
    try {
      final model = await remoteDatasource.selectSavingGoal(userId, id);
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpiredGoalCheckModel>> checkExpiredSavingGoal(int userId) async {
    try {
      final model = await remoteDatasource.checkExpiredSavingGoal(userId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsNotified(int id) async {
    try {
      final res = await remoteDatasource.markAsNotified(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingGoalEntity>> extendSavingGoal(
    int id,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) async {
    try {
      final model = await remoteDatasource.extendSavingGoal(id, newEndDate, newStartDate: newStartDate);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavingGoalReportModel>> getSavingGoalReport(int id) async {
    try {
      final model = await remoteDatasource.getSavingGoalReport(id);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
