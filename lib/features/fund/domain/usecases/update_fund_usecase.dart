import 'package:fpdart/fpdart.dart';
import 'package:money_care/features/fund/data/models/models.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/domain/repositories/fund_repository.dart';
import 'package:money_care/core/errors/failure.dart';

class UpdateFundUseCase {
  final FundRepository repository;
  UpdateFundUseCase(this.repository);

  Future<Either<Failure, FundEntity>> call(FundDto dto) {
    return repository.updateFund(dto);
  }
}
