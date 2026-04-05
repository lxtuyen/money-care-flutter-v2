import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/fund/data/models/models.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/core/errors/failure.dart';

abstract class FundRepository {
  Future<Either<Failure, FundEntity>> createFund(FundDto dto);
  Future<Either<Failure, List<FundEntity>>> getFundsByUser(int userId);
  Future<Either<Failure, FundEntity>> getFund(int id);
  Future<Either<Failure, FundEntity>> updateFund(FundDto dto);
  Future<Either<Failure, void>> deleteFund(int id);
  Future<Either<Failure, FundEntity>> selectFund(int userId, int fundId);
  Future<Either<Failure, ExpiredFundCheckModel>> checkExpiredFund(int userId);
  Future<Either<Failure, bool>> markAsNotified(int fundId);
  Future<Either<Failure, FundEntity>> extendFund(int fundId, DateTime newEndDate, {DateTime? newStartDate});
  Future<Either<Failure, FundReportModel>> getFundReport(int fundId);
}
