// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totals_by_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TotalsByDateEntityModelImpl _$$TotalsByDateEntityModelImplFromJson(
  Map<String, dynamic> json,
) => _$TotalsByDateEntityModelImpl(
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

Map<String, dynamic> _$$TotalsByDateEntityModelImplToJson(
  _$TotalsByDateEntityModelImpl instance,
) => <String, dynamic>{'income': instance.income, 'expense': instance.expense};
