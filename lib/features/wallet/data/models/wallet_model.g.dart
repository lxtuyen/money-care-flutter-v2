// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => _WalletModel(
  id: NumParser.parseInt(json['id']),
  name: json['name'] as String? ?? '',
  balance: json['balance'] == null ? 0 : NumParser.parseDouble(json['balance']),
  isActive: json['is_active'] as bool? ?? true,
  savingGoals:
      (json['savingGoals'] as List<dynamic>?)
          ?.map((e) => SavingGoalModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WalletModelToJson(_WalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'is_active': instance.isActive,
      'savingGoals': instance.savingGoals,
    };
