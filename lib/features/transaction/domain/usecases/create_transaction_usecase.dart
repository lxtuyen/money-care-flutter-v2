import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<TransactionEntity> call(
    TransactionCreateDto dto, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) {
    return repository.createTransaction(
      dto,
      coupleId: coupleId,
      payerId: payerId,
      splitMethod: splitMethod,
      splits: splits,
    );
  }
}
