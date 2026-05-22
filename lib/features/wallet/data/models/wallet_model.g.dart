// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => _WalletModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  balance: (json['balance'] as num?)?.toDouble() ?? 0,
  icon: json['icon'] as String?,
  color: json['color'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  type: json['type'] as String? ?? 'regular',
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
      'icon': instance.icon,
      'color': instance.color,
      'is_active': instance.isActive,
      'type': instance.type,
      'savingGoals': instance.savingGoals,
    };
