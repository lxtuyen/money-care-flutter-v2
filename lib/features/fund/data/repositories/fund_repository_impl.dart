import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/fund/data/datasources/fund_remote_datasource.dart';
import 'package:money_care/features/fund/data/models/models.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/domain/repositories/fund_repository.dart';

class FundRepositoryImpl implements FundRepository {
  final FundRemoteDatasource remoteDatasource;

  FundRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, FundEntity>> createFund(
    FundDto dto,
  ) async {
    try {
      final model = await remoteDatasource.createFund(dto);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<FundEntity>>> getFundsByUser(
    int userId,
  ) async {
    try {
      final models = await remoteDatasource.getFundsByUser(userId);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundEntity>> getFund(int id) async {
    try {
      final model = await remoteDatasource.getFund(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundEntity>> updateFund(
    FundDto dto,
  ) async {
    try {
      final model = await remoteDatasource.updateFund(dto);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFund(int id) async {
    try {
      await remoteDatasource.deleteFund(id);
      return Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundEntity>> selectFund(
    int userId,
    int fundId,
  ) async {
    try {
      final model = await remoteDatasource.selectFund(userId, fundId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpiredFundCheckModel>> checkExpiredFund(int userId) async {
    try {
      final model = await remoteDatasource.checkExpiredFund(userId);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsNotified(int fundId) async {
    try {
      await remoteDatasource.markAsNotified(fundId);
      return const Right(true);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundEntity>> extendFund(
    int fundId,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) async {
    try {
      final model = await remoteDatasource.extendFund(
        fundId,
        newEndDate,
        newStartDate: newStartDate,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FundReportModel>> getFundReport(int fundId) async {
    try {
      final model = await remoteDatasource.getFundReport(fundId);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object error) {
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }
    if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
