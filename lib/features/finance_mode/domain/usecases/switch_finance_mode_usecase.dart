import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/domain/repositories/finance_mode_repository.dart';

class SwitchFinanceModeParams {
  final int userId;
  final FinanceMode mode;

  const SwitchFinanceModeParams({
    required this.userId,
    required this.mode,
  });
}

/// Cho phép người dùng chuyển đổi chế độ tài chính thủ công (Req 5.2)
class SwitchFinanceModeUseCase {
  final FinanceModeRepository repository;

  SwitchFinanceModeUseCase(this.repository);

  Future<Either<Failure, FinanceModeEntity>> call(
      SwitchFinanceModeParams params) async {
    final currentResult = await repository.getFinanceMode(params.userId);

    return currentResult.fold(
      (failure) => Left(failure),
      (current) {
        final updated = FinanceModeEntity(
          userId: params.userId,
          mode: params.mode,
          updatedAt: DateTime.now(),
          suggestionCooldownUntil: current.suggestionCooldownUntil,
        );
        return repository.saveFinanceMode(updated);
      },
    );
  }
}
