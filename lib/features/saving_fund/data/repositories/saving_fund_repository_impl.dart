import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_fund/data/datasources/saving_fund_remote_datasource.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';

class SavingFundRepositoryImpl implements SavingFundRepository {
  final SavingFundRemoteDatasource remoteDatasource;

  SavingFundRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, SavingFundEntity>> createSavingFund(
    SavingFundDto dto,
  ) async {
    try {
      final model = await remoteDatasource.createSavingFund(dto);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SavingFundEntity>>> getSavingFundsByUser(
    int userId,
  ) async {
    try {
      final models = await remoteDatasource.getSavingFundsByUser(userId);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SavingFundEntity>> getSavingFund(int id) async {
    try {
      final model = await remoteDatasource.getSavingFund(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SavingFundEntity>> updateSavingFund(
    SavingFundDto dto,
  ) async {
    try {
      final model = await remoteDatasource.updateSavingFund(dto);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavingFund(int id) async {
    try {
      await remoteDatasource.deleteSavingFund(id);
      return Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SavingFundEntity>> selectSavingFund(
    int userId,
    int fundId,
  ) async {
    try {
      final model = await remoteDatasource.selectSavingFund(userId, fundId);
      return Right(model.toEntity());
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
