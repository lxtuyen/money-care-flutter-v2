// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_by_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionByTypeModel _$TransactionByTypeModelFromJson(
  Map<String, dynamic> json,
) => _TransactionByTypeModel(
  income:
      (json['income'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  expense:
      (json['expense'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TransactionByTypeModelToJson(
  _TransactionByTypeModel instance,
) => <String, dynamic>{'income': instance.income, 'expense': instance.expense};
