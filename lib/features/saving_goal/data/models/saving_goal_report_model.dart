import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';

part 'saving_goal_report_model.freezed.dart';
part 'saving_goal_report_model.g.dart';

@freezed
abstract class MilestoneModel with _$MilestoneModel {
  const factory MilestoneModel({
    required String label,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0) double target,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0) double actual,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
  }) = _MilestoneModel;

  factory MilestoneModel.fromJson(Map<String, dynamic> json) =>
      _$MilestoneModelFromJson(json);
}

@freezed
abstract class CategorySpendingModel with _$CategorySpendingModel {
  const factory CategorySpendingModel({
    @JsonKey(name: 'category_name') required String categoryName,
    @Default(0) int percentage,
    @Default(0) double total,
  }) = _CategorySpendingModel;

  factory CategorySpendingModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySpendingModelFromJson(json);
}

@freezed
abstract class SavingGoalReportModel with _$SavingGoalReportModel {
  const factory SavingGoalReportModel({
    @JsonKey(fromJson: NumParser.parseInt) required int id,
    required String name,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(fromJson: NumParser.parseDouble) @Default(0) double target,
    @JsonKey(name: 'current_balance', fromJson: NumParser.parseDouble)
    @Default(0)
    double currentBalance,
    @JsonKey(name: 'progress_percent', fromJson: NumParser.parseInt)
    @Default(0)
    int progressPercent,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'completion_notified') @Default(false) bool completionNotified,
    @JsonKey(name: 'current_milestone_index', fromJson: NumParser.parseInt)
    @Default(-1)
    int currentMilestoneIndex,
    @Default([]) List<MilestoneModel> milestones,
    @Default(0) int balanceUsagePercentage,
    @Default(0) double totalSpent,
    @Default(false) bool isOverBudget,
    @Default(0) int targetCompletionPercentage,
    @Default(false) bool isTargetAchieved,
    @Default([]) List<CategorySpendingModel> categoryBreakdown,
    @Default(0) int totalTransactions,
    @Default(0) double dailyAverageSpending,
    @Default(0) double remainingBudget,

  }) = _SavingGoalReportModel;

  factory SavingGoalReportModel.fromJson(Map<String, dynamic> json) =>
      _$SavingGoalReportModelFromJson(json);
}
