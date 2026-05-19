import 'package:flutter/material.dart';

class SubCategoryEntity {
  final int? id;
  final String name;
  final String icon;
  final String? type;
  final bool isSystem;
  final int? categoryId;

  const SubCategoryEntity({
    this.id,
    required this.name,
    required this.icon,
    this.type,
    this.isSystem = false,
    this.categoryId,
  });
}

class CategoryEntity {
  final int? id;
  final String name;
  final String icon;
  final Color? color;
  final bool isEssential;
  final String? type;
  final double spendingPercentage;
  final bool isSystem;
  final List<SubCategoryEntity> subCategories;

  const CategoryEntity({
    this.id,
    required this.name,
    required this.icon,
    this.color,
    this.isEssential = true,
    this.type,
    this.spendingPercentage = 0,
    this.isSystem = false,
    this.subCategories = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
