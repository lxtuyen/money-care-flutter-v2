import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class SelectSavingFundUseCase {
  final SavingFundRepository repository;
  SelectSavingFundUseCase(this.repository);

  Future<Either<Failure, SavingFundEntity>> call(int userId, int fundId) {
    return repository.selectSavingFund(userId, fundId);
  }
}
