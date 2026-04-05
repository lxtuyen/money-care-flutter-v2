import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/domain/repositories/fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class GetFundUseCase {
  final FundRepository repository;
  GetFundUseCase(this.repository);

  Future<Either<Failure, FundEntity>> call(int id) {
    return repository.getFund(id);
  }
}
