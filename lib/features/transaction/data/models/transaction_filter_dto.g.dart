// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_filter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionFilterDto _$TransactionFilterDtoFromJson(
  Map<String, dynamic> json,
) => _TransactionFilterDto(
  categoryId: (json['categoryId'] as num?)?.toInt(),
  goalId: (json['savingGoalId'] as num?)?.toInt(),
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
);

Map<String, dynamic> _$TransactionFilterDtoToJson(
  _TransactionFilterDto instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'savingGoalId': instance.goalId,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'limit': instance.limit,
};
