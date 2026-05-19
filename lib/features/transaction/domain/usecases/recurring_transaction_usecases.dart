import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';
import 'package:money_care/features/transaction/domain/repositories/recurring_transaction_repository.dart';

class GetRecurringTransactionsUseCase {
  final RecurringTransactionRepository repository;
  GetRecurringTransactionsUseCase(this.repository);
  Future<List<RecurringTransactionModel>> call(int userId) =>
      repository.findAllByUser(userId);
}

class CreateRecurringTransactionUseCase {
  final RecurringTransactionRepository repository;
  CreateRecurringTransactionUseCase(this.repository);
  Future<RecurringTransactionModel> call(CreateRecurringTransactionDto dto) =>
      repository.create(dto);
}

class DeleteRecurringTransactionUseCase {
  final RecurringTransactionRepository repository;
  DeleteRecurringTransactionUseCase(this.repository);
  Future<bool> call(int id) => repository.remove(id);
}
