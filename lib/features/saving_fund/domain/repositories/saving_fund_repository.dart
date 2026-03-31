import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/core/errors/failure.dart';

abstract class SavingFundRepository {
  Future<Either<Failure, SavingFundEntity>> createSavingFund(SavingFundDto dto);
  Future<Either<Failure, List<SavingFundEntity>>> getSavingFundsByUser(int userId);
  Future<Either<Failure, SavingFundEntity>> getSavingFund(int id);
  Future<Either<Failure, SavingFundEntity>> updateSavingFund(SavingFundDto dto);
  Future<Either<Failure, void>> deleteSavingFund(int id);
  Future<Either<Failure, SavingFundEntity>> selectSavingFund(int userId, int fundId);
  Future<Either<Failure, ExpiredFundCheckModel>> checkExpiredFund(int userId);
  Future<Either<Failure, bool>> markAsNotified(int fundId);
  Future<Either<Failure, SavingFundEntity>> extendFund(int fundId, DateTime newEndDate, {DateTime? newStartDate});
  Future<Either<Failure, SavingFundReportModel>> getFundReport(int fundId);
}
