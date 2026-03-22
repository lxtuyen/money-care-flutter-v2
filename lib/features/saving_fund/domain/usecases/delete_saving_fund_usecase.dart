import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class DeleteSavingFundUseCase {
  final SavingFundRepository repository;
  DeleteSavingFundUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteSavingFund(id);
  }
}
