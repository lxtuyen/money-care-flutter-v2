// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: (json['id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      pictureUrl: _readPictureUrl(json, 'picture_url') as String?,
      transactionDate: json['transaction_date'] == null
          ? null
          : DateTime.parse(json['transaction_date'] as String),
      note: json['note'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'picture_url': instance.pictureUrl,
      'transaction_date': instance.transactionDate?.toIso8601String(),
      'note': instance.note,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'category': instance.category,
    };
