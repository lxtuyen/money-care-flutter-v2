import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class FilterTransactionsUseCase {
  final TransactionRepository repository;

  FilterTransactionsUseCase(this.repository);

  Future<TransactionByTypeEntity> call(int userId, TransactionFilterDto dto) {
    return repository.findAllByFilter(userId, dto);
  }
}
