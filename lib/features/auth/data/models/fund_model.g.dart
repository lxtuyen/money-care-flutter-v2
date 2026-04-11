// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FundModel _$FundModelFromJson(Map<String, dynamic> json) => _FundModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  isSelected: json['is_selected'] as bool?,
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$FundModelToJson(_FundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_selected': instance.isSelected,
      'categories': instance.categories,
    };
