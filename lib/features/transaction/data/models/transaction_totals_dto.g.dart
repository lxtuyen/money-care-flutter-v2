// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_totals_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionTotalsDto _$TransactionTotalsDtoFromJson(
  Map<String, dynamic> json,
) => _TransactionTotalsDto(
  fundId: (json['fundId'] as num?)?.toInt(),
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$TransactionTotalsDtoToJson(
  _TransactionTotalsDto instance,
) => <String, dynamic>{
  'fundId': instance.fundId,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'type': instance.type,
};
