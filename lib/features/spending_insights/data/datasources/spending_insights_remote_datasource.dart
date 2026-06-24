import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/features/spending_insights/data/models/recurring_transaction_model.dart';

abstract class SpendingInsightsRemoteDataSource {
  Future<RecurringDetectResponseModel> getRecurringTransactions({
    int months = 6,
    double minConfidence = 0.5,
    bool forceRefresh = false,
  });

  Future<List<RecurringTransactionModel>> getConfirmedRecurring();

  Future<void> confirmRecurring(Map<String, dynamic> body);

  Future<void> dismissRecurring(String aiRecurringId);

  Future<void> updateConfirmedRecurring(int id, Map<String, dynamic> updates);

  Future<void> deleteConfirmedRecurring(int id);
}

class SpendingInsightsRemoteDataSourceImpl
    implements SpendingInsightsRemoteDataSource {
  final ApiClient api;

  SpendingInsightsRemoteDataSourceImpl({required this.api});

  @override
  Future<RecurringDetectResponseModel> getRecurringTransactions({
    int months = 6,
    double minConfidence = 0.5,
    bool forceRefresh = false,
  }) async {
    final res = await api.get<RecurringDetectResponseModel>(
      ApiRoutes.recurringTransactions,
      queryParameters: {
        'months': months,
        'minConfidence': minConfidence,
        if (forceRefresh) 'forceRefresh': 'true',
      },
      fromJsonT: (json) =>
          RecurringDetectResponseModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<List<RecurringTransactionModel>> getConfirmedRecurring() async {
    final res = await api.get<Map<String, dynamic>>(
      ApiRoutes.recurringConfirmed,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    final data = res.unwrap();
    final items = data['items'] as List? ?? [];
    return items
        .map((e) =>
            RecurringTransactionModel.fromConfirmedJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> confirmRecurring(Map<String, dynamic> body) async {
    await api.post(ApiRoutes.recurringConfirm, body: body);
  }

  @override
  Future<void> dismissRecurring(String aiRecurringId) async {
    await api.post(
      ApiRoutes.recurringDismiss,
      body: {'aiRecurringId': aiRecurringId},
    );
  }

  @override
  Future<void> updateConfirmedRecurring(
      int id, Map<String, dynamic> updates) async {
    await api.patch(ApiRoutes.recurringConfirmedItem(id), body: updates);
  }

  @override
  Future<void> deleteConfirmedRecurring(int id) async {
    await api.delete(ApiRoutes.recurringConfirmedItem(id));
  }
}
