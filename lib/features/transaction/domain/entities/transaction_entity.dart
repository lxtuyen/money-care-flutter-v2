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
  final SubCategoryEntity? subCategory;
  final int? walletId;
  final String? walletName;

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
    this.subCategory,
    this.walletId,
    this.walletName,
  });

  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    final categoryData = map['category'];
    final subCategoryData = map['subCategory'];
    final categoryName = categoryData is Map
        ? categoryData['name']?.toString()
        : categoryData?.toString();
    final categoryIcon = categoryData is Map
        ? categoryData['icon']?.toString()
        : map['categoryIcon']?.toString();

    return TransactionEntity(
      id: map['id'] is int ? map['id'] : null,
      amount: map['amount'] ?? 0,
      type: map['type'] ?? 'expense',
      note: map['note'],
      walletId: map['walletId'] is int ? map['walletId'] : null,
      walletName: map['walletName'],
      transactionDate: map['date'] != null
          ? DateTime.tryParse(map['date'].toString())
          : null,
      category: CategoryEntity(
        id: categoryData is Map && categoryData['id'] is int
            ? categoryData['id'] as int
            : null,
        name: categoryName ?? 'Khác',
        icon: categoryIcon ?? '💰',
        type: map['type'],
      ),
      subCategory: subCategoryData is Map
          ? SubCategoryEntity(
              id: subCategoryData['id'] is int
                  ? subCategoryData['id'] as int
                  : null,
              name: subCategoryData['name']?.toString() ?? '',
              icon: subCategoryData['icon']?.toString() ?? '',
              type: map['type'],
            )
          : subCategoryData is String
          ? SubCategoryEntity(
              name: subCategoryData,
              icon: map['subCategoryIcon']?.toString() ?? '',
              type: map['type'],
            )
          : null,
    );
  }
}
