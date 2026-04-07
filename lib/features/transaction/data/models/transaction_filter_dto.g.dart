// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_filter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionFilterDtoImpl _$$TransactionFilterDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionFilterDtoImpl(
  categoryId: (json['categoryId'] as num?)?.toInt(),
  fundId: (json['fundId'] as num?)?.toInt(),
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
);

Map<String, dynamic> _$$TransactionFilterDtoImplToJson(
  _$TransactionFilterDtoImpl instance,
) => <String, dynamic>{
  if (instance.categoryId case final value?) 'categoryId': value,
  if (instance.fundId case final value?) 'fundId': value,
  if (instance.startDate case final value?) 'start_date': value,
  if (instance.endDate case final value?) 'end_date': value,
};
