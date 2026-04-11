// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_mode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinanceModeModel _$FinanceModeModelFromJson(Map<String, dynamic> json) =>
    _FinanceModeModel(
      userId: (json['userId'] as num).toInt(),
      mode: json['mode'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      suggestionCooldownUntil: json['suggestionCooldownUntil'] == null
          ? null
          : DateTime.parse(json['suggestionCooldownUntil'] as String),
    );

Map<String, dynamic> _$FinanceModeModelToJson(_FinanceModeModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'mode': _modeToJson(instance.mode),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'suggestionCooldownUntil': instance.suggestionCooldownUntil
          ?.toIso8601String(),
    };
