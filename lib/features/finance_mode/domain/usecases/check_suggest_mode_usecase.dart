import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/domain/repositories/finance_mode_repository.dart';

const double kSavingThreshold = 50.0;

const double kSurvivalThreshold = 80.0;

class CheckSuggestModeUseCase {
  final FinanceModeRepository repository;

  CheckSuggestModeUseCase(this.repository);

  Future<Either<Failure, FinanceMode?>> call({
    required int userId,
    required double spentPercent,
  }) async {
    final result = await repository.getFinanceMode(userId);

    return result.fold(
      (failure) => Left(failure),
      (entity) {
        if (entity.suggestionCooldownUntil != null &&
            DateTime.now().isBefore(entity.suggestionCooldownUntil!)) {
          return const Right(null);
        }

        if (spentPercent > kSurvivalThreshold) {
          return const Right(FinanceMode.survival);
        }

        if (spentPercent > kSavingThreshold) {
          return const Right(FinanceMode.saving);
        }

        return const Right(null);
      },
    );
  }
}
