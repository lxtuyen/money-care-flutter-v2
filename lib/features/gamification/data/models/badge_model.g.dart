// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeModelImpl _$$BadgeModelImplFromJson(Map<String, dynamic> json) =>
    _$BadgeModelImpl(
      key: json['key'] as String,
      name: json['name'] as String,
      awardedAt: DateTime.parse(json['awardedAt'] as String),
    );

Map<String, dynamic> _$$BadgeModelImplToJson(_$BadgeModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'awardedAt': instance.awardedAt.toIso8601String(),
    };
