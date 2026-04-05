import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/domain/repositories/fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class SelectFundUseCase {
  final FundRepository repository;
  SelectFundUseCase(this.repository);

  Future<Either<Failure, FundEntity>> call(int userId, int fundId) {
    return repository.selectFund(userId, fundId);
  }
}
