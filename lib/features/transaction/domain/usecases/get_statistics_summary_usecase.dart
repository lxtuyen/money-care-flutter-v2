import 'package:money_care/features/transaction/domain/entities/statistics_summary_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class GetStatisticsSummaryUseCase {
  final TransactionRepository repository;

  GetStatisticsSummaryUseCase({required this.repository});

  Future<StatisticsSummaryEntity> call(int userId) async {
    return await repository.getStatisticsSummary(userId);
  }
}
