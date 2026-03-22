import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class GetSavingFundsByUserUseCase {
  final SavingFundRepository repository;
  GetSavingFundsByUserUseCase(this.repository);

  Future<Either<Failure, List<SavingFundEntity>>> call(int userId) {
    return repository.getSavingFundsByUser(userId);
  }
}
