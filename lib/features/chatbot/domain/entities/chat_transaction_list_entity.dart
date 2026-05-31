import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class ChatTransactionListEntity {
  final List<TransactionEntity> transactions;
  final int total;
  final String type;
  final String? startDate;
  final String? endDate;

  const ChatTransactionListEntity({
    required this.transactions,
    required this.total,
    required this.type,
    this.startDate,
    this.endDate,
  });

  factory ChatTransactionListEntity.fromMap(Map<String, dynamic> map) {
    final List transactionMaps = map['transactions'] as List? ?? [];
    final transactions = transactionMaps
        .map((m) => TransactionEntity.fromMap(m as Map<String, dynamic>))
        .toList();
    final int total = map['total'] as int? ?? transactions.length;
    final Map<String, dynamic> query =
        map['query'] as Map<String, dynamic>? ?? {};

    return ChatTransactionListEntity(
      transactions: transactions,
      total: total,
      type: query['type'] as String? ?? 'all',
      startDate: query['startDate'] as String?,
      endDate: query['endDate'] as String?,
    );
  }
}
