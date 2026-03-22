import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

class SavingFundDto {
  final String? name;
  final List<CategoryEntity>? categories;
  final int? id;
  final double? targetAmount;
  final DateTime? startDate;
  final DateTime? endDate;

  SavingFundDto({
    this.name,
    this.categories,
    this.id,
    this.targetAmount,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJsonCreate() {
    return {
      'name': name,
      'categories':
          categories
              ?.map(
                (e) => {
                  'id': e.id,
                  'name': e.name,
                  'percentage': e.percentage,
                  'icon': e.icon,
                  'color': e.color,
                },
              )
              .toList(),
      'userId': id,
      'targetAmount': targetAmount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'name': name,
      'categories':
          categories
              ?.map(
                (e) => {
                  'id': e.id,
                  'name': e.name,
                  'percentage': e.percentage,
                  'icon': e.icon,
                  'color': e.color,
                },
              )
              .toList(),
      'targetAmount': targetAmount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
