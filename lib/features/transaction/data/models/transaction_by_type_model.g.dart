// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_by_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionByTypeModelImpl _$$TransactionByTypeModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionByTypeModelImpl(
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

Map<String, dynamic> _$$TransactionByTypeModelImplToJson(
  _$TransactionByTypeModelImpl instance,
) => <String, dynamic>{'income': instance.income, 'expense': instance.expense};
