// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expired_fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpiredFundInfoModel _$ExpiredFundInfoModelFromJson(
  Map<String, dynamic> json,
) => _ExpiredFundInfoModel(
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

Map<String, dynamic> _$ExpiredFundInfoModelToJson(
  _ExpiredFundInfoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'end_date': instance.endDate?.toIso8601String(),
  'completion_percentage': instance.completionPercentage,
  'total_spent': instance.totalSpent,
  'target': instance.target,
  'balance': instance.balance,
};

_ExpiredFundCheckModel _$ExpiredFundCheckModelFromJson(
  Map<String, dynamic> json,
) => _ExpiredFundCheckModel(
  hasExpiredFund: json['has_expired_fund'] as bool? ?? false,
  expiredFund: json['expired_fund'] == null
      ? null
      : ExpiredFundInfoModel.fromJson(
          json['expired_fund'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ExpiredFundCheckModelToJson(
  _ExpiredFundCheckModel instance,
) => <String, dynamic>{
  'has_expired_fund': instance.hasExpiredFund,
  'expired_fund': instance.expiredFund,
};
