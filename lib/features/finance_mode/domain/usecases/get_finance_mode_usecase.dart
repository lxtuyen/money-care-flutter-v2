import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/domain/repositories/finance_mode_repository.dart';

class GetFinanceModeUseCase {
  final FinanceModeRepository repository;

  GetFinanceModeUseCase(this.repository);

  Future<Either<Failure, FinanceModeEntity>> call(int userId) {
    return repository.getFinanceMode(userId);
  }
}
