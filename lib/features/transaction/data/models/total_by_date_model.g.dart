// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_by_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalByDateEntityModel _$TotalByDateEntityModelFromJson(
  Map<String, dynamic> json,
) => _TotalByDateEntityModel(
  date: DateTime.parse(json['date'] as String),
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TotalByDateEntityModelToJson(
  _TotalByDateEntityModel instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'total': instance.total,
};
