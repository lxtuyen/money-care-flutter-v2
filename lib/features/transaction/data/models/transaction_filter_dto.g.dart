// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_filter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionFilterDto _$TransactionFilterDtoFromJson(
  Map<String, dynamic> json,
) => _TransactionFilterDto(
  categoryId: (json['categoryId'] as num?)?.toInt(),
  walletId: (json['walletId'] as num?)?.toInt(),
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
  includeTransfer: json['includeTransfer'] as String?,
);

Map<String, dynamic> _$TransactionFilterDtoToJson(
  _TransactionFilterDto instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'walletId': instance.walletId,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'limit': instance.limit,
  'includeTransfer': instance.includeTransfer,
};
