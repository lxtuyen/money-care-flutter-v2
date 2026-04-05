import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

class FundDto {
  final String? name;
  final List<CategoryEntity>? categories;
  final int? id;
  final double? balance;
  final double? target;
  final DateTime? start_date;
  final DateTime? end_date;

  final String? type;

  FundDto({
    this.name,
    this.type,
    this.categories,
    this.id,
    this.balance,
    this.target,
    this.start_date,
    this.end_date,
  });

  Map<String, dynamic> toJsonCreate() {
    return {
      'name': name,
      'type': type,
      'categories':
          categories
              ?.map(
                (e) => <String, dynamic>{
                  'name': e.name,
                  'percentage': e.percentage,
                  'icon': e.icon,
                },
              )
              .toList(),
      'userId': id,
      'balance': balance,
      'target': target,
      'start_date': start_date?.toIso8601String(),
      'end_date': end_date?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'name': name,
      'type': type,
      'categories':
          categories
              ?.map(
                (e) => <String, dynamic>{
                  'id': e.id,
                  'name': e.name,
                  'percentage': e.percentage,
                  'icon': e.icon,
                },
              )
              .toList(),
      'balance': balance,
      'target': target,
      'start_date': start_date?.toIso8601String(),
      'end_date': end_date?.toIso8601String(),
    };
  }
}
