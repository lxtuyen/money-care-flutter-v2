import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class GetFirstTransactionDateUseCase {
  final TransactionRepository repository;

  GetFirstTransactionDateUseCase({required this.repository});

  Future<DateTime?> call(int userId) async {
    return await repository.getFirstTransactionDate(userId);
  }
}
