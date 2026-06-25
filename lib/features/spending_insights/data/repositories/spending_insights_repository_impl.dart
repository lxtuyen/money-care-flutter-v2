import 'package:money_care/features/spending_insights/data/datasources/spending_insights_remote_datasource.dart';
import 'package:money_care/features/spending_insights/domain/entities/recurring_transaction_entity.dart';
import 'package:money_care/features/spending_insights/domain/repositories/spending_insights_repository.dart';

class SpendingInsightsRepositoryImpl implements SpendingInsightsRepository {
  final SpendingInsightsRemoteDataSource remoteDataSource;

  SpendingInsightsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RecurringDetectResult> getRecurringTransactions({
    int months = 6,
    double minConfidence = 0.5,
    bool forceRefresh = false,
  }) async {
    final model = await remoteDataSource.getRecurringTransactions(
      months: months,
      minConfidence: minConfidence,
      forceRefresh: forceRefresh,
    );
    return model.toEntity();
  }

  @override
  Future<List<RecurringTransactionEntity>> getConfirmedRecurring() async {
    final models = await remoteDataSource.getConfirmedRecurring();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> confirmRecurring(RecurringTransactionEntity item) async {
    await remoteDataSource.confirmRecurring({
      'aiRecurringId': item.recurringId,
      'description': item.description,
      'categoryName': item.categoryName,
      'categoryIcon': item.categoryIcon,
      'averageAmount': item.averageAmount,
      'frequency': item.frequency,
      'monthlyEstimate': item.monthlyEstimate,
      if (item.expectedDay != null) 'expectedDay': item.expectedDay,
    });
  }

  @override
  Future<void> dismissRecurring(String aiRecurringId) async {
    await remoteDataSource.dismissRecurring(aiRecurringId);
  }

  @override
  Future<void> updateConfirmedRecurring(
      int id, Map<String, dynamic> updates) async {
    await remoteDataSource.updateConfirmedRecurring(id, updates);
  }

  @override
  Future<void> deleteConfirmedRecurring(int id) async {
    await remoteDataSource.deleteConfirmedRecurring(id);
  }
}
