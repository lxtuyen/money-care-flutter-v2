// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_by_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TotalByDateEntityModelImpl _$$TotalByDateEntityModelImplFromJson(
  Map<String, dynamic> json,
) => _$TotalByDateEntityModelImpl(
  date: DateTime.parse(json['date'] as String),
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TotalByDateEntityModelImplToJson(
  _$TotalByDateEntityModelImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'total': instance.total,
};
