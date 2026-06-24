import 'package:money_care/features/spending_insights/domain/entities/recurring_transaction_entity.dart';

abstract class SpendingInsightsRepository {
  Future<RecurringDetectResult> getRecurringTransactions({
    int months = 6,
    double minConfidence = 0.5,
    bool forceRefresh = false,
  });

  Future<List<RecurringTransactionEntity>> getConfirmedRecurring();

  Future<void> confirmRecurring(RecurringTransactionEntity item);

  Future<void> dismissRecurring(String aiRecurringId);

  Future<void> updateConfirmedRecurring(int id, Map<String, dynamic> updates);

  Future<void> deleteConfirmedRecurring(int id);
}
