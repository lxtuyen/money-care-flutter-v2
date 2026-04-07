// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FundModelImpl _$$FundModelImplFromJson(Map<String, dynamic> json) =>
    _$FundModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isSelected: json['is_selected'] as bool?,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FundModelImplToJson(_$FundModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_selected': instance.isSelected,
      'categories': instance.categories,
    };
