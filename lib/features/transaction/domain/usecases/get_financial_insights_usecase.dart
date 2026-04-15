import 'package:money_care/features/transaction/domain/entities/ai_insight_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class GetFinancialInsightsUseCase {
  final TransactionRepository repository;

  GetFinancialInsightsUseCase({required this.repository});

  Future<AiInsightEntity> call(int userId, {int? fundId, String? period}) async {
    return await repository.getFinancialInsights(userId, fundId: fundId, period: period);
  }
}
