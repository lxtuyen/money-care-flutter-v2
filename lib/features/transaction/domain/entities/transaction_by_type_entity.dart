import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionByTypeEntity {
  final List<TransactionEntity> incomeTransactions;
  final List<TransactionEntity> expenseTransactions;

  const TransactionByTypeEntity({required this.incomeTransactions, required this.expenseTransactions});
}
