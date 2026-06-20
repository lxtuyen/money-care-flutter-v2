import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';

part 'budget_suggestion_model.freezed.dart';
part 'budget_suggestion_model.g.dart';

@freezed
abstract class BudgetSuggestionGoalModel with _$BudgetSuggestionGoalModel {
  const factory BudgetSuggestionGoalModel({
    @JsonKey(fromJson: NumParser.parseInt) required int id,
    @Default('') String name,
    @JsonKey(name: 'monthlyBudget', fromJson: NumParser.parseDouble) required double monthlyBudget,
  }) = _BudgetSuggestionGoalModel;

  factory BudgetSuggestionGoalModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetSuggestionGoalModelFromJson(json);
}

@freezed
abstract class BudgetSuggestionModel with _$BudgetSuggestionModel {
  const factory BudgetSuggestionModel({
    @JsonKey(name: 'averageMonthlySavings', fromJson: NumParser.parseDouble) required double averageMonthlySavings,
    @JsonKey(name: 'totalExistingBudget', fromJson: NumParser.parseDouble) required double totalExistingBudget,
    @JsonKey(name: 'availableSavings', fromJson: NumParser.parseDouble) required double availableSavings,
    @JsonKey(name: 'requiredMonthly', fromJson: NumParser.parseDouble) required double requiredMonthly,
    @JsonKey(name: 'isSufficient') required bool isSufficient,
    @JsonKey(name: 'deficit', fromJson: NumParser.parseDouble) required double deficit,
    @JsonKey(name: 'existingGoals') required List<BudgetSuggestionGoalModel> existingGoals,
    @JsonKey(name: 'confidenceScore', fromJson: NumParser.parseDouble) required double confidenceScore,
  }) = _BudgetSuggestionModel;

  factory BudgetSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetSuggestionModelFromJson(json);
}
