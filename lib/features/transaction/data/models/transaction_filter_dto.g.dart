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
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
);

Map<String, dynamic> _$TransactionFilterDtoToJson(
  _TransactionFilterDto instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'savingGoalId': instance.goalId,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'limit': instance.limit,
};
