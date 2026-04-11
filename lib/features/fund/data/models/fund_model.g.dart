// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FundModel _$FundModelFromJson(Map<String, dynamic> json) => _FundModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String?,
  isSelected: json['is_selected'] as bool?,
  categories: (json['categories'] as List<dynamic>)
      .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  balance: (json['balance'] as num?)?.toDouble(),
  monthlyLimit: (json['monthly_limit'] as num?)?.toDouble(),
  spentCurrentMonth: (json['spent_current_month'] as num?)?.toDouble() ?? 0,
  notified70: json['notified_70'] as bool? ?? false,
  notified90: json['notified_90'] as bool? ?? false,
  target: (json['target'] as num?)?.toDouble(),
  savedAmount: (json['saved_amount'] as num?)?.toDouble() ?? 0,
  isCompleted: json['is_completed'] as bool? ?? false,
  templateKey: json['template_key'] as String?,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  status: json['status'] as String?,
);

Map<String, dynamic> _$FundModelToJson(_FundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'is_selected': instance.isSelected,
      'categories': instance.categories,
      'balance': instance.balance,
      'monthly_limit': instance.monthlyLimit,
      'spent_current_month': instance.spentCurrentMonth,
      'notified_70': instance.notified70,
      'notified_90': instance.notified90,
      'target': instance.target,
      'saved_amount': instance.savedAmount,
      'is_completed': instance.isCompleted,
      'template_key': instance.templateKey,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'status': instance.status,
    };
