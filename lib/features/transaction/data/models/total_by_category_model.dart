import 'package:money_care/features/transaction/data/models/category_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TotalByCategoryEntityModel {
  final CategoryModel category;
  final int total;

  TotalByCategoryEntityModel({required this.category, required this.total});

  factory TotalByCategoryEntityModel.fromJson(Map<String, dynamic> json) {
    return TotalByCategoryEntityModel(
      category: CategoryModel.fromJson(json['category']),
      total: (json['total'] ?? 0).toInt(),
    );
  }

  TotalByCategoryEntity toEntity() => TotalByCategoryEntity(
    categoryName: category.name,
    total: total,
    categoryIcon: category.icon,
    percentage: category.percentage,
    color: category.color,
  );
}
