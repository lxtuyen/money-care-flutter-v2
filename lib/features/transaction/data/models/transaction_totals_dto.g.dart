// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_totals_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionTotalsDto _$TransactionTotalsDtoFromJson(
  Map<String, dynamic> json,
) => _TransactionTotalsDto(
  goalId: (json['savingGoalId'] as num?)?.toInt(),
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$TransactionTotalsDtoToJson(
  _TransactionTotalsDto instance,
) => <String, dynamic>{
  'savingGoalId': instance.goalId,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'type': instance.type,
};
