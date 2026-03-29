import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TotalByCategoryEntityModel {
  final String categoryName;
  final String categoryIcon;
  final double percentage;
  final double limit;
  final int total;

  TotalByCategoryEntityModel({
    required this.categoryName,
    required this.categoryIcon,
    required this.percentage,
    required this.limit,
    required this.total,
  });

  factory TotalByCategoryEntityModel.fromJson(Map<String, dynamic> json) {
    return TotalByCategoryEntityModel(
      categoryName: json['categoryName'] ?? '',
      categoryIcon: json['categoryIcon'] ?? '',
      percentage: (json['percentage'] ?? 0).toDouble(),
      limit: (json['limit'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toInt(),
    );
  }

  TotalByCategoryEntity toEntity() => TotalByCategoryEntity(
    categoryName: categoryName,
    total: total,
    categoryIcon: categoryIcon,
    percentage: percentage,
    limit: limit,
    color: null,
  );
}
