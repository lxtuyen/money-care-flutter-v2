import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund_report_model.freezed.dart';
part 'fund_report_model.g.dart';

@freezed
class CategorySpendingModel with _$CategorySpendingModel {
  const factory CategorySpendingModel({
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'category_name') required String categoryName,
    @JsonKey(name: 'total_spent') @Default(0) double totalSpent,
    @JsonKey(name: 'transaction_count') @Default(0) int transactionCount,
    @Default(0) int percentage,
  }) = _CategorySpendingModel;

  factory CategorySpendingModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySpendingModelFromJson(json);
}

@freezed
class FundReportModel with _$FundReportModel {
  const factory FundReportModel({
    @JsonKey(name: 'fund_id') required int fundId,
    @JsonKey(name: 'fund_name') required String fundName,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @Default('EXPIRED') String status,
    @Default(0) double balance,
    @Default(0) double target,
    @JsonKey(name: 'total_spent') @Default(0) double totalSpent,
    @JsonKey(name: 'remaining_balance') @Default(0) double remainingBudget,
    @JsonKey(name: 'balance_usage_percentage') @Default(0) int balanceUsagePercentage,
    @JsonKey(name: 'target_completion_percentage') @Default(0) int targetCompletionPercentage,
    @JsonKey(name: 'is_over_balance') @Default(false) bool isOverBudget,
    @JsonKey(name: 'is_target_achieved') @Default(false) bool isTargetAchieved,
    @JsonKey(name: 'category_breakdown')
    @Default([])
    List<CategorySpendingModel> categoryBreakdown,
    @JsonKey(name: 'total_transactions') @Default(0) int totalTransactions,
    @JsonKey(name: 'average_transaction_amount')
    @Default(0)
    double averageTransactionAmount,
    @JsonKey(name: 'duration_days') @Default(0) int durationDays,
    @JsonKey(name: 'daily_average_spending') @Default(0) double dailyAverageSpending,
  }) = _FundReportModel;

  factory FundReportModel.fromJson(Map<String, dynamic> json) =>
      _$FundReportModelFromJson(json);
}
