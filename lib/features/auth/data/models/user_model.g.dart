// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  role: json['role'] as String,
  isVip: json['isVip'] as bool?,
  accessToken: json['accessToken'] as String?,
  profile: UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
  fund: json['fund'] == null
      ? null
      : FundModel.fromJson(json['fund'] as Map<String, dynamic>),
  hasCategories: json['hasCategories'] as bool?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'isVip': instance.isVip,
      'accessToken': instance.accessToken,
      'profile': instance.profile,
      'fund': instance.fund,
      'hasCategories': instance.hasCategories,
    };
