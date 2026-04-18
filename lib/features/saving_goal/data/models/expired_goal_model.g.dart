// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expired_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpiredGoalInfoModel _$ExpiredGoalInfoModelFromJson(
  Map<String, dynamic> json,
) => _ExpiredGoalInfoModel(
  id: NumParser.parseInt(json['id']),
  name: json['name'] as String,
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  completionPercentage: json['completion_percentage'] == null
      ? 0
      : NumParser.parseInt(json['completion_percentage']),
  totalSpent: json['total_spent'] == null
      ? 0
      : NumParser.parseDouble(json['total_spent']),
  target: json['target'] == null ? 0 : NumParser.parseDouble(json['target']),
  balance: json['balance'] == null ? 0 : NumParser.parseDouble(json['balance']),
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
