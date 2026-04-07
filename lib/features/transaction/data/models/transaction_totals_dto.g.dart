// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_totals_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionTotalsDtoImpl _$$TransactionTotalsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionTotalsDtoImpl(
  fundId: (json['fundId'] as num?)?.toInt(),
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$$TransactionTotalsDtoImplToJson(
  _$TransactionTotalsDtoImpl instance,
) => <String, dynamic>{
  if (instance.fundId case final value?) 'fundId': value,
  if (instance.startDate case final value?) 'start_date': value,
  if (instance.endDate case final value?) 'end_date': value,
  if (instance.type case final value?) 'type': value,
};
