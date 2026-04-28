// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinancialAnalysisModel _$FinancialAnalysisModelFromJson(
  Map<String, dynamic> json,
) => _FinancialAnalysisModel(
  summary: json['summary'] as String? ?? '',
  budgetPlan:
      (json['budget_plan'] as List<dynamic>?)
          ?.map((e) => BudgetGroupModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$FinancialAnalysisModelToJson(
  _FinancialAnalysisModel instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'budget_plan': instance.budgetPlan,
};

_BudgetGroupModel _$BudgetGroupModelFromJson(Map<String, dynamic> json) =>
    _BudgetGroupModel(
      groupName: json['group_name'] as String? ?? 'Khác',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => BudgetItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BudgetGroupModelToJson(_BudgetGroupModel instance) =>
    <String, dynamic>{
      'group_name': instance.groupName,
      'items': instance.items,
    };

_BudgetItemModel _$BudgetItemModelFromJson(Map<String, dynamic> json) =>
    _BudgetItemModel(
      name: json['name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$BudgetItemModelToJson(_BudgetItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'description': instance.description,
    };
