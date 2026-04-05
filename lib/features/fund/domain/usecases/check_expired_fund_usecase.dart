import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/fund/data/models/models.dart';
import 'package:money_care/features/fund/domain/repositories/fund_repository.dart';

class CheckExpiredFundUseCase {
  final FundRepository repository;
  CheckExpiredFundUseCase(this.repository);

  Future<Either<Failure, ExpiredFundCheckModel>> call(int userId) {
    return repository.checkExpiredFund(userId);
  }
}

class MarkAsNotifiedUseCase {
  final FundRepository repository;
  MarkAsNotifiedUseCase(this.repository);

  Future<Either<Failure, bool>> call(int fundId) {
    return repository.markAsNotified(fundId);
  }
}

class ExtendFundUseCase {
  final FundRepository repository;
  ExtendFundUseCase(this.repository);

  Future<Either<Failure, dynamic>> call(
    int fundId,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) {
    return repository.extendFund(fundId, newEndDate, newStartDate: newStartDate);
  }
}

class GetFundReportUseCase {
  final FundRepository repository;
  GetFundReportUseCase(this.repository);

  Future<Either<Failure, FundReportModel>> call(int fundId) {
    return repository.getFundReport(fundId);
  }
}
