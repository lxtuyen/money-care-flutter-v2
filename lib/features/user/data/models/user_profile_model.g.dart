// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileUpdateDtoImpl _$$ProfileUpdateDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProfileUpdateDtoImpl(
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  monthlyIncome: (json['monthly_income'] as num?)?.toInt(),
  incomeDate:
      json['income_date'] == null
          ? null
          : DateTime.parse(json['income_date'] as String),
);

Map<String, dynamic> _$$ProfileUpdateDtoImplToJson(
  _$ProfileUpdateDtoImpl instance,
) => <String, dynamic>{
  if (instance.firstName case final value?) 'first_name': value,
  if (instance.lastName case final value?) 'last_name': value,
  if (instance.monthlyIncome case final value?) 'monthly_income': value,
  if (instance.incomeDate?.toIso8601String() case final value?)
    'income_date': value,
};

_$UserUpdateDtoImpl _$$UserUpdateDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserUpdateDtoImpl(
      role: json['role'] as String?,
      isVip: json['isVip'] as bool?,
    );

Map<String, dynamic> _$$UserUpdateDtoImplToJson(_$UserUpdateDtoImpl instance) =>
    <String, dynamic>{'role': instance.role, 'isVip': instance.isVip};

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserProfileModelImpl(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  monthlyIncome: (json['monthly_income'] as num?)?.toInt(),
  incomeDate:
      json['income_date'] == null
          ? null
          : DateTime.parse(json['income_date'] as String),
);

Map<String, dynamic> _$$UserProfileModelImplToJson(
  _$UserProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'monthly_income': instance.monthlyIncome,
  'income_date': instance.incomeDate?.toIso8601String(),
};
