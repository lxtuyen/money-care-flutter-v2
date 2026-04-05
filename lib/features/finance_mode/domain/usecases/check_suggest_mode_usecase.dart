import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/domain/repositories/finance_mode_repository.dart';

/// Ngưỡng gợi ý chuyển sang SAVING (Req 5.3)
const double kSavingThreshold = 50.0;

/// Ngưỡng gợi ý chuyển sang SURVIVAL (Req 5.4)
const double kSurvivalThreshold = 80.0;

/// Kiểm tra và trả về gợi ý chế độ tài chính dựa trên % chi tiêu (Req 5.3, 5.4, 5.5)
///
/// Trả về [Right(FinanceMode)] nếu có gợi ý, [Right(null)] nếu không cần gợi ý
/// hoặc đang trong cooldown 24h.
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
        // Kiểm tra cooldown 24h (Req 5.5)
        if (entity.suggestionCooldownUntil != null &&
            DateTime.now().isBefore(entity.suggestionCooldownUntil!)) {
          return const Right(null);
        }

        // Gợi ý SURVIVAL khi > 80% (Req 5.4)
        if (spentPercent > kSurvivalThreshold) {
          return const Right(FinanceMode.survival);
        }

        // Gợi ý SAVING khi > 50% (Req 5.3)
        if (spentPercent > kSavingThreshold) {
          return const Right(FinanceMode.saving);
        }

        return const Right(null);
      },
    );
  }
}
