// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_by_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalByTypeModel _$TotalByTypeModelFromJson(Map<String, dynamic> json) =>
    _TotalByTypeModel(
      income: (json['income_total'] as num).toInt(),
      expense: (json['expense_total'] as num).toInt(),
      currentSaving: (json['current_saving'] as num).toInt(),
      targetSaving: (json['target_saving'] as num).toInt(),
    );

Map<String, dynamic> _$TotalByTypeModelToJson(_TotalByTypeModel instance) =>
    <String, dynamic>{
      'income_total': instance.income,
      'expense_total': instance.expense,
      'current_saving': instance.currentSaving,
      'target_saving': instance.targetSaving,
    };
