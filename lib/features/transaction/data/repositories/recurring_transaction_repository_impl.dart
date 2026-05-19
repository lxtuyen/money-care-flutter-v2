import 'package:money_care/features/transaction/data/datasources/recurring_transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';
import 'package:money_care/features/transaction/domain/repositories/recurring_transaction_repository.dart';

class RecurringTransactionRepositoryImpl
    implements RecurringTransactionRepository {
  final RecurringTransactionRemoteDataSource remoteDataSource;

  RecurringTransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RecurringTransactionModel>> findAllByUser(int userId) {
    return remoteDataSource.findAllByUser(userId);
  }

  @override
  Future<RecurringTransactionModel> create(CreateRecurringTransactionDto dto) {
    return remoteDataSource.create(dto);
  }

  @override
  Future<bool> remove(int id) {
    return remoteDataSource.remove(id);
  }
}
