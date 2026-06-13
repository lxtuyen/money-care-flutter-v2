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
  final int? payerId;
  final String? payerName;
  final int? coupleId;
  final int? creatorId;
  final String? creatorName;
  final String? splitMethod;
  final String? settlementStatus;
  final List<TransactionSplitEntity>? splits;

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
    this.payerId,
    this.payerName,
    this.coupleId,
    this.creatorId,
    this.creatorName,
    this.splitMethod,
    this.settlementStatus,
    this.splits,
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

    final payerData = map['payer'];
    final creatorData = map['creator'];
    final payerId = map['payerId'] is int
        ? map['payerId'] as int
        : payerData is Map && payerData['id'] is int
        ? payerData['id'] as int
        : null;
    final payerName = map['payerName']?.toString() ??
        (payerData is Map ? payerData['fullName']?.toString() : null);
    final coupleId = map['coupleId'] is int ? map['coupleId'] as int : null;
    final creatorId = map['creatorId'] is int
        ? map['creatorId'] as int
        : creatorData is Map && creatorData['id'] is int
        ? creatorData['id'] as int
        : null;
    final creatorName =
        map['creatorName']?.toString() ??
        (creatorData is Map ? creatorData['fullName']?.toString() : null);

    final splitsData = map['splits'] as List<dynamic>?;
    final parsedSplits = splitsData != null
        ? splitsData
              .map(
                (s) => TransactionSplitEntity.fromMap(
                  Map<String, dynamic>.from(s),
                ),
              )
              .toList()
        : <TransactionSplitEntity>[];

    return TransactionEntity(
      id: map['id'] is int ? map['id'] : null,
      amount: map['amount'] ?? 0,
      type: map['type'] ?? 'expense',
      note: map['note'],
      walletId: map['walletId'] is int ? map['walletId'] : null,
      walletName: map['walletName'],
      payerId: payerId,
      payerName: payerName,
      coupleId: coupleId,
      creatorId: creatorId,
      creatorName: creatorName,
      splitMethod: map['splitMethod'],
      settlementStatus: map['settlementStatus'],
      splits: parsedSplits,
      transactionDate: map['date'] != null
          ? DateTime.tryParse(map['date'].toString())
          : map['transaction_date'] != null
          ? DateTime.tryParse(map['transaction_date'].toString())
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

class TransactionSplitEntity {
  final int userId;
  final String userName;
  final double amount;
  final double? percent;

  TransactionSplitEntity({
    required this.userId,
    required this.userName,
    required this.amount,
    this.percent,
  });

  factory TransactionSplitEntity.fromMap(Map<String, dynamic> map) {
    return TransactionSplitEntity(
      userId: map['userId'] ?? 0,
      userName: map['userName'] ?? map['fullName'] ?? 'Thành viên',
      amount: double.parse(map['amount']?.toString() ?? '0'),
      percent: map['percent'] != null
          ? double.parse(map['percent'].toString())
          : null,
    );
  }
}
