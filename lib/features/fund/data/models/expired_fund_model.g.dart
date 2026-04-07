// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expired_fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpiredFundInfoModelImpl _$$ExpiredFundInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExpiredFundInfoModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  endDate:
      json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
  completionPercentage: (json['completion_percentage'] as num?)?.toInt() ?? 0,
  totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
  target: (json['target'] as num?)?.toDouble() ?? 0,
  balance: (json['balance'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$$ExpiredFundInfoModelImplToJson(
  _$ExpiredFundInfoModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'end_date': instance.endDate?.toIso8601String(),
  'completion_percentage': instance.completionPercentage,
  'total_spent': instance.totalSpent,
  'target': instance.target,
  'balance': instance.balance,
};

_$ExpiredFundCheckModelImpl _$$ExpiredFundCheckModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExpiredFundCheckModelImpl(
  hasExpiredFund: json['has_expired_fund'] as bool? ?? false,
  expiredFund:
      json['expired_fund'] == null
          ? null
          : ExpiredFundInfoModel.fromJson(
            json['expired_fund'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$$ExpiredFundCheckModelImplToJson(
  _$ExpiredFundCheckModelImpl instance,
) => <String, dynamic>{
  'has_expired_fund': instance.hasExpiredFund,
  'expired_fund': instance.expiredFund,
};
