import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';

abstract class RecurringTransactionRemoteDataSource {
  Future<List<RecurringTransactionModel>> findAllByUser(int userId);
  Future<RecurringTransactionModel> create(CreateRecurringTransactionDto dto);
  Future<bool> remove(int id);
}

class RecurringTransactionRemoteDataSourceImpl implements RecurringTransactionRemoteDataSource {
  final ApiClient api;

  RecurringTransactionRemoteDataSourceImpl({required this.api});

  @override
  Future<List<RecurringTransactionModel>> findAllByUser(int userId) async {
    final res = await api.get<List<RecurringTransactionModel>>(
      'recurring-transactions/user/$userId',
      fromJsonT: (json) {
        final list = json as List;
        return list.map((e) => RecurringTransactionModel.fromJson(e)).toList();
      },
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<RecurringTransactionModel> create(CreateRecurringTransactionDto dto) async {
    final res = await api.post<RecurringTransactionModel>(
      'recurring-transactions',
      body: dto.toJson(),
      fromJsonT: (json) => RecurringTransactionModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<bool> remove(int id) async {
    final res = await api.delete<void>('recurring-transactions/$id');
    return res.success;
  }
}
