// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String? ?? '',
      color: const ColorConverter().fromJson(json['color']),
      isEssential: json['isEssential'] as bool? ?? true,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'percentage': instance.percentage,
      'icon': instance.icon,
      'color': const ColorConverter().toJson(instance.color),
      'isEssential': instance.isEssential,
      'type': instance.type,
    };
