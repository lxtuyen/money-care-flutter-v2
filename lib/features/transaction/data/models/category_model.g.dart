// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String? ?? '',
      color: const ColorConverter().fromJson(json['color']),
      isEssential: json['isEssential'] as bool? ?? true,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'percentage': instance.percentage,
      'icon': instance.icon,
      'color': const ColorConverter().toJson(instance.color),
      'isEssential': instance.isEssential,
      'type': instance.type,
    };
