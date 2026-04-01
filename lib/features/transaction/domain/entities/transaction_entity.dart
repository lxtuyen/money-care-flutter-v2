import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

export 'category_entity.dart';
export 'total_by_category_entity.dart';
export 'total_by_date_entity.dart';
export 'total_by_type_entity.dart';
export 'totals_by_date_entity.dart';
export 'transaction_by_type_entity.dart';
export 'statistics_summary_entity.dart';

class TransactionEntity {
  final int? id;
  final int amount;
  final String type;
  final String? pictureUrl;
  final DateTime? transactionDate;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CategoryEntity? category;

  const TransactionEntity({
    this.id,
    required this.amount,
    required this.type,
    this.pictureUrl,
    this.transactionDate,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.category,
  });
}
