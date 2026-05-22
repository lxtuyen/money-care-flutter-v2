// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expired_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpiredGoalInfoModel _$ExpiredGoalInfoModelFromJson(
  Map<String, dynamic> json,
) => _ExpiredGoalInfoModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  completionPercentage: (json['completion_percentage'] as num?)?.toInt() ?? 0,
  totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
  target: (json['target'] as num?)?.toDouble() ?? 0,
  balance: (json['balance'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$ExpiredGoalInfoModelToJson(
  _ExpiredGoalInfoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'end_date': instance.endDate?.toIso8601String(),
  'completion_percentage': instance.completionPercentage,
  'total_spent': instance.totalSpent,
  'target': instance.target,
  'balance': instance.balance,
};

_ExpiredGoalCheckModel _$ExpiredGoalCheckModelFromJson(
  Map<String, dynamic> json,
) => _ExpiredGoalCheckModel(
  hasExpiredGoal: json['has_expired_fund'] as bool? ?? false,
  expiredGoal: json['expired_fund'] == null
      ? null
      : ExpiredGoalInfoModel.fromJson(
          json['expired_fund'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ExpiredGoalCheckModelToJson(
  _ExpiredGoalCheckModel instance,
) => <String, dynamic>{
  'has_expired_fund': instance.hasExpiredGoal,
  'expired_fund': instance.expiredGoal,
};
