// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totals_by_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalsByDateEntityModel _$TotalsByDateEntityModelFromJson(
  Map<String, dynamic> json,
) => _TotalsByDateEntityModel(
  income:
      (json['income'] as List<dynamic>?)
          ?.map(
            (e) => TotalByDateEntityModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  expense:
      (json['expense'] as List<dynamic>?)
          ?.map(
            (e) => TotalByDateEntityModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$TotalsByDateEntityModelToJson(
  _TotalsByDateEntityModel instance,
) => <String, dynamic>{'income': instance.income, 'expense': instance.expense};
