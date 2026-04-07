// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GamificationModelImpl _$$GamificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$GamificationModelImpl(
  userId: (json['userId'] as num).toInt(),
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  lastTransactionDate:
      json['lastTransactionDate'] == null
          ? null
          : DateTime.parse(json['lastTransactionDate'] as String),
  badges:
      (json['badges'] as List<dynamic>?)
          ?.map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$GamificationModelImplToJson(
  _$GamificationModelImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'currentStreak': instance.currentStreak,
  'lastTransactionDate': instance.lastTransactionDate?.toIso8601String(),
  'badges': instance.badges,
};
