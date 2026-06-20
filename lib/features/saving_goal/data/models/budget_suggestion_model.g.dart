// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetSuggestionGoalModel _$BudgetSuggestionGoalModelFromJson(
  Map<String, dynamic> json,
) => _BudgetSuggestionGoalModel(
  id: NumParser.parseInt(json['id']),
  name: json['name'] as String? ?? '',
  monthlyBudget: NumParser.parseDouble(json['monthlyBudget']),
);

Map<String, dynamic> _$BudgetSuggestionGoalModelToJson(
  _BudgetSuggestionGoalModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'monthlyBudget': instance.monthlyBudget,
};

_BudgetSuggestionModel _$BudgetSuggestionModelFromJson(
  Map<String, dynamic> json,
) => _BudgetSuggestionModel(
  averageMonthlySavings: NumParser.parseDouble(json['averageMonthlySavings']),
  totalExistingBudget: NumParser.parseDouble(json['totalExistingBudget']),
  availableSavings: NumParser.parseDouble(json['availableSavings']),
  requiredMonthly: NumParser.parseDouble(json['requiredMonthly']),
  isSufficient: json['isSufficient'] as bool,
  deficit: NumParser.parseDouble(json['deficit']),
  existingGoals: (json['existingGoals'] as List<dynamic>)
      .map((e) => BudgetSuggestionGoalModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  confidenceScore: NumParser.parseDouble(json['confidenceScore']),
);

Map<String, dynamic> _$BudgetSuggestionModelToJson(
  _BudgetSuggestionModel instance,
) => <String, dynamic>{
  'averageMonthlySavings': instance.averageMonthlySavings,
  'totalExistingBudget': instance.totalExistingBudget,
  'availableSavings': instance.availableSavings,
  'requiredMonthly': instance.requiredMonthly,
  'isSufficient': instance.isSufficient,
  'deficit': instance.deficit,
  'existingGoals': instance.existingGoals,
  'confidenceScore': instance.confidenceScore,
};
