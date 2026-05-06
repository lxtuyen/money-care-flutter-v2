import 'package:flutter/material.dart';

class CategoryEntity {
  final int? id;
  final String name;
  final String icon;
  final Color? color;
  final bool isEssential;
  final String? type;
  final double spendingPercentage;

  const CategoryEntity({
    this.id,
    required this.name,
    required this.icon,
    this.color,
    this.isEssential = true,
    this.type,
    this.spendingPercentage = 0,
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
