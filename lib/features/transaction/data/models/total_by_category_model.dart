import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TotalByCategoryEntityModel {
  final String categoryName;
  final String categoryIcon;
  final double percentage;
  final double spendingPercentage;
  final double limit;
  final int total;
  final bool isEssential;

  TotalByCategoryEntityModel({
    required this.categoryName,
    required this.categoryIcon,
    required this.percentage,
    required this.spendingPercentage,
    required this.limit,
    required this.total,
    required this.isEssential,
  });

  factory TotalByCategoryEntityModel.fromJson(Map<String, dynamic> json) {
    return TotalByCategoryEntityModel(
      categoryName: json['categoryName'] ?? '',
      categoryIcon: json['categoryIcon'] ?? '',
      percentage: (json['percentage'] ?? 0).toDouble(),
      spendingPercentage: (json['spendingPercentage'] ?? 0).toDouble(),
      limit: (json['limit'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toInt(),
      isEssential: json['isEssential'] ?? true,
    );
  }

  TotalByCategoryEntity toEntity() => TotalByCategoryEntity(
    categoryName: categoryName,
    total: total,
    categoryIcon: categoryIcon,
    percentage: percentage,
    spendingPercentage: spendingPercentage,
    limit: limit,
    isEssential: isEssential,
    color: null,
  );
}
