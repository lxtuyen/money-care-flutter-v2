import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/fund/domain/repositories/fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class DeleteFundUseCase {
  final FundRepository repository;
  DeleteFundUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteFund(id);
  }
}
