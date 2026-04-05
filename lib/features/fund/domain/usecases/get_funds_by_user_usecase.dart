import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/domain/repositories/fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class GetFundsByUserUseCase {
  final FundRepository repository;
  GetFundsByUserUseCase(this.repository);

  Future<Either<Failure, List<FundEntity>>> call(int userId) {
    return repository.getFundsByUser(userId);
  }
}
