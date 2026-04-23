import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';

abstract class FinanceModeRepository {
  Future<Either<Failure, FinanceModeEntity>> getFinanceMode(int userId);
  Future<Either<Failure, FinanceModeEntity>> saveFinanceMode(
    FinanceModeEntity financeMode,
  );
}
