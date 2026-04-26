import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_analysis_model.freezed.dart';
part 'financial_analysis_model.g.dart';

@freezed
class FinancialAnalysisModel with _$FinancialAnalysisModel {
  const factory FinancialAnalysisModel({
    @Default('') String summary,
    @JsonKey(name: 'budget_plan') @Default([]) List<BudgetGroupModel> budgetPlan,
  }) = _FinancialAnalysisModel;

  factory FinancialAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$FinancialAnalysisModelFromJson(json);
}

@freezed
class BudgetGroupModel with _$BudgetGroupModel {
  const factory BudgetGroupModel({
    @JsonKey(name: 'group_name') @Default('Khác') String groupName,
    @Default([]) List<BudgetItemModel> items,
  }) = _BudgetGroupModel;

  factory BudgetGroupModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetGroupModelFromJson(json);
}

@freezed
class BudgetItemModel with _$BudgetItemModel {
  const factory BudgetItemModel({
    @Default('') String name,
    @Default(0.0) double amount,
    @Default('') String description,
  }) = _BudgetItemModel;

  factory BudgetItemModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetItemModelFromJson(json);
}
