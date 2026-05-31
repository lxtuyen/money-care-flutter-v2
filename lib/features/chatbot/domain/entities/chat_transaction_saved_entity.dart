import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class ChatTransactionSavedEntity {
  final bool isDeleted;
  final TransactionEntity transaction;
  final bool isIncome;
  final bool needsClarification;
  final List<String> suggestions;

  const ChatTransactionSavedEntity({
    required this.isDeleted,
    required this.transaction,
    required this.isIncome,
    required this.needsClarification,
    required this.suggestions,
  });

  factory ChatTransactionSavedEntity.fromMap(Map<String, dynamic> map) {
    final transaction = TransactionEntity.fromMap(map);
    final suggestions = (map['suggestedSubCategories'] as List? ?? [])
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();

    return ChatTransactionSavedEntity(
      isDeleted: map['isDeleted'] == true,
      transaction: transaction,
      isIncome: transaction.type == 'income',
      needsClarification: map['needsClarification'] == true,
      suggestions: suggestions,
    );
  }
}
