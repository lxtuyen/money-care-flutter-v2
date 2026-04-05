import 'package:flutter/material.dart';

class CategoryEntity {
  final int? id;
  final String name;
  final int percentage;
  final String icon;
  final Color? color;
  final bool isEssential;
  final String? type;

  const CategoryEntity({
    this.id,
    required this.name,
    this.percentage = 0,
    required this.icon,
    this.color,
    this.isEssential = true,
    this.type,
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
