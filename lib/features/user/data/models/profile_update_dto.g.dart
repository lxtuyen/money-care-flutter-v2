// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileUpdateDto _$ProfileUpdateDtoFromJson(Map<String, dynamic> json) =>
    _ProfileUpdateDto(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toInt(),
      incomeDate: json['incomeDate'] == null
          ? null
          : DateTime.parse(json['incomeDate'] as String),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$ProfileUpdateDtoToJson(_ProfileUpdateDto instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'monthlyIncome': instance.monthlyIncome,
      'incomeDate': instance.incomeDate?.toIso8601String(),
      'avatar': instance.avatar,
    };
