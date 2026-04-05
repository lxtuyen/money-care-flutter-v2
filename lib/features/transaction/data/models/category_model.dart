import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final int? id;
  final String name;
  final int percentage;
  final String icon;
  final Color? color;
  final bool isEssential;
  final String? type;

  CategoryModel({
    this.id,
    required this.name,
    this.percentage = 0,
    required this.icon,
    this.color,
    this.isEssential = true,
    this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      percentage: json['percentage'] ?? 0,
      icon: json['icon'] ?? '',
      color: json['color'],
      isEssential: json['isEssential'] ?? true,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'percentage': percentage,
      'icon': icon,
      'color': color,
      'isEssential': isEssential,
      if (type != null) 'type': type,
    };
  }

  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    percentage: percentage,
    icon: icon,
    color: color,
    isEssential: isEssential,
    type: type,
  );
}
