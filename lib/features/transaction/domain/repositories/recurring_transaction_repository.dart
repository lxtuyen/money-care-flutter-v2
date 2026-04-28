import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';

abstract class RecurringTransactionRepository {
  Future<List<RecurringTransactionModel>> findAllByUser(int userId);
  Future<RecurringTransactionModel> create(CreateRecurringTransactionDto dto);
  Future<bool> remove(int id);
}
