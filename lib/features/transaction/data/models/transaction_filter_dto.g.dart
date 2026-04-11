// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_filter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionFilterDto _$TransactionFilterDtoFromJson(
  Map<String, dynamic> json,
) => _TransactionFilterDto(
  categoryId: (json['categoryId'] as num?)?.toInt(),
  fundId: (json['fundId'] as num?)?.toInt(),
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
);

Map<String, dynamic> _$TransactionFilterDtoToJson(
  _TransactionFilterDto instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'fundId': instance.fundId,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
};
