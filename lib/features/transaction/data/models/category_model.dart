import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class CategoryModel {
  final int? id;
  final String name;
  final int percentage;
  final String icon;
  final String? color;

  CategoryModel({
    this.id,
    required this.name,
    this.percentage = 0,
    required this.icon,
    this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      percentage: json['percentage'] ?? 0,
      icon: json['icon'] ?? '',
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'percentage': percentage, 'icon': icon, 'color': color};
  }

  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    percentage: percentage,
    icon: icon,
    color: color,
  );
}
