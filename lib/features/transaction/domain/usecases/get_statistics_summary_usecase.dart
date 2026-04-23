import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/statistics_summary_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class GetStatisticsSummaryUseCase {
  final TransactionRepository repository;

  GetStatisticsSummaryUseCase({required this.repository});

  Future<StatisticsSummaryEntity> call(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    return await repository.getStatisticsSummary(userId, dto);
  }
}
