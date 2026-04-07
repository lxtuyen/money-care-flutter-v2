// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_mode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinanceModeModelImpl _$$FinanceModeModelImplFromJson(
  Map<String, dynamic> json,
) => _$FinanceModeModelImpl(
  userId: (json['userId'] as num).toInt(),
  mode: json['mode'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  suggestionCooldownUntil:
      json['suggestionCooldownUntil'] == null
          ? null
          : DateTime.parse(json['suggestionCooldownUntil'] as String),
);

Map<String, dynamic> _$$FinanceModeModelImplToJson(
  _$FinanceModeModelImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'mode': _modeToJson(instance.mode),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'suggestionCooldownUntil':
      instance.suggestionCooldownUntil?.toIso8601String(),
};
