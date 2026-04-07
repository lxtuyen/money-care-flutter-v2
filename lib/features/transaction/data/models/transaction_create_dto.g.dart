// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_create_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionCreateDtoImpl _$$TransactionCreateDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionCreateDtoImpl(
  amount: (json['amount'] as num?)?.toInt(),
  type: json['type'] as String?,
  note: json['note'] as String?,
  pictureUrl: json['pictuteURL'] as String?,
  transactionDate:
      json['transactionDate'] == null
          ? null
          : DateTime.parse(json['transactionDate'] as String),
  categoryId: (json['categoryId'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  fundId: (json['fundId'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TransactionCreateDtoImplToJson(
  _$TransactionCreateDtoImpl instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'type': instance.type,
  'note': instance.note,
  'pictuteURL': instance.pictureUrl,
  'transactionDate': instance.transactionDate?.toIso8601String(),
  'categoryId': instance.categoryId,
  'userId': instance.userId,
  'fundId': instance.fundId,
};
