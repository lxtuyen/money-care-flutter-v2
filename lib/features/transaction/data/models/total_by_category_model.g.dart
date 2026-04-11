// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_by_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalByCategoryEntityModel _$TotalByCategoryEntityModelFromJson(
  Map<String, dynamic> json,
) => _TotalByCategoryEntityModel(
  categoryName: json['categoryName'] as String? ?? '',
  categoryIcon: json['categoryIcon'] as String? ?? '',
  percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
  spendingPercentage: (json['spendingPercentage'] as num?)?.toDouble() ?? 0.0,
  limit: (json['limit'] as num?)?.toDouble() ?? 0.0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  isEssential: json['isEssential'] as bool? ?? true,
);

Map<String, dynamic> _$TotalByCategoryEntityModelToJson(
  _TotalByCategoryEntityModel instance,
) => <String, dynamic>{
  'categoryName': instance.categoryName,
  'categoryIcon': instance.categoryIcon,
  'percentage': instance.percentage,
  'spendingPercentage': instance.spendingPercentage,
  'limit': instance.limit,
  'total': instance.total,
  'isEssential': instance.isEssential,
};
