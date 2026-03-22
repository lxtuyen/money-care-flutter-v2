import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/repositories/saving_fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class CreateSavingFundUseCase {
  final SavingFundRepository repository;
  CreateSavingFundUseCase(this.repository);

  Future<Either<Failure, SavingFundEntity>> call(SavingFundDto dto) {
    return repository.createSavingFund(dto);
  }
}
