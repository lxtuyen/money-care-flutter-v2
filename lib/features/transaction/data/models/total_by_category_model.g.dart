// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_by_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalByCategoryEntityModel _$TotalByCategoryEntityModelFromJson(
  Map<String, dynamic> json,
) => _TotalByCategoryEntityModel(
  categoryId: NumParser.parseIntNullable(json['category_id']),
  categoryName: json['categoryName'] as String? ?? '',
  categoryIcon: json['categoryIcon'] as String? ?? '',
  percentage: json['percentage'] == null
      ? 0.0
      : NumParser.parseDouble(json['percentage']),
  spendingPercentage: json['spendingPercentage'] == null
      ? 0.0
      : NumParser.parseDouble(json['spendingPercentage']),
  limit: json['limit'] == null ? 0.0 : NumParser.parseDouble(json['limit']),
  total: json['total'] == null ? 0 : NumParser.parseInt(json['total']),
  isEssential: json['isEssential'] as bool? ?? true,
);

Map<String, dynamic> _$TotalByCategoryEntityModelToJson(
  _TotalByCategoryEntityModel instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'categoryName': instance.categoryName,
  'categoryIcon': instance.categoryIcon,
  'percentage': instance.percentage,
  'spendingPercentage': instance.spendingPercentage,
  'limit': instance.limit,
  'total': instance.total,
  'isEssential': instance.isEssential,
};
