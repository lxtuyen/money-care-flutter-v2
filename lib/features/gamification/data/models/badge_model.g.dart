// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeModel _$BadgeModelFromJson(Map<String, dynamic> json) => _BadgeModel(
  key: json['key'] as String,
  name: json['name'] as String,
  awardedAt: DateTime.parse(json['awardedAt'] as String),
);

Map<String, dynamic> _$BadgeModelToJson(_BadgeModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'awardedAt': instance.awardedAt.toIso8601String(),
    };
