import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<TransactionEntity> call(
    TransactionCreateDto dto,
    int id, {
    int? coupleId,
    int? payerId,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) {
    return repository.updateTransaction(
      dto,
      id,
      coupleId: coupleId,
      payerId: payerId,
      splitMethod: splitMethod,
      splits: splits,
    );
  }
}
