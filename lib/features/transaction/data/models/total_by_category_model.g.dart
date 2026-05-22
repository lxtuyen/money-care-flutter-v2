// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_by_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalByCategoryEntityModel _$TotalByCategoryEntityModelFromJson(
  Map<String, dynamic> json,
) => _TotalByCategoryEntityModel(
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['categoryName'] as String? ?? '',
  categoryIcon: json['categoryIcon'] as String? ?? '',
  spendingPercentage: (json['spendingPercentage'] as num?)?.toDouble() ?? 0.0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  isEssential: json['isEssential'] as bool? ?? true,
);

Map<String, dynamic> _$TotalByCategoryEntityModelToJson(
  _TotalByCategoryEntityModel instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'categoryName': instance.categoryName,
  'categoryIcon': instance.categoryIcon,
  'spendingPercentage': instance.spendingPercentage,
  'total': instance.total,
  'isEssential': instance.isEssential,
};
