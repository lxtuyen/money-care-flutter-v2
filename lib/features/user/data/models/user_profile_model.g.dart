// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      monthlyIncome: (json['monthly_income'] as num?)?.toInt(),
      incomeDate: json['income_date'] == null
          ? null
          : DateTime.parse(json['income_date'] as String),
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'monthly_income': instance.monthlyIncome,
      'income_date': instance.incomeDate?.toIso8601String(),
    };
