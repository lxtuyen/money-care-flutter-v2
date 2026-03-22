import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<bool> call(int id) {
    return repository.deleteTransaction(id);
  }
}
