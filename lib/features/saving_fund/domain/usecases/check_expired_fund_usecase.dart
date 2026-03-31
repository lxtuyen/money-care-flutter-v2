import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';

class CheckExpiredFundUseCase {
  final SavingFundRepository repository;
  CheckExpiredFundUseCase(this.repository);

  Future<Either<Failure, ExpiredFundCheckModel>> call(int userId) {
    return repository.checkExpiredFund(userId);
  }
}

class MarkAsNotifiedUseCase {
  final SavingFundRepository repository;
  MarkAsNotifiedUseCase(this.repository);

  Future<Either<Failure, bool>> call(int fundId) {
    return repository.markAsNotified(fundId);
  }
}

class ExtendFundUseCase {
  final SavingFundRepository repository;
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
  final SavingFundRepository repository;
  GetFundReportUseCase(this.repository);

  Future<Either<Failure, SavingFundReportModel>> call(int fundId) {
    return repository.getFundReport(fundId);
  }
}
