// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategorySpendingModel _$CategorySpendingModelFromJson(
  Map<String, dynamic> json,
) => _CategorySpendingModel(
  categoryId: (json['category_id'] as num).toInt(),
  categoryName: json['category_name'] as String,
  totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
  transactionCount: (json['transaction_count'] as num?)?.toInt() ?? 0,
  percentage: (json['percentage'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CategorySpendingModelToJson(
  _CategorySpendingModel instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'total_spent': instance.totalSpent,
  'transaction_count': instance.transactionCount,
  'percentage': instance.percentage,
};

_FundReportModel _$FundReportModelFromJson(Map<String, dynamic> json) =>
    _FundReportModel(
      fundId: (json['fund_id'] as num).toInt(),
      fundName: json['fund_name'] as String,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      status: json['status'] as String? ?? 'EXPIRED',
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      target: (json['target'] as num?)?.toDouble() ?? 0,
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
      remainingBudget: (json['remaining_balance'] as num?)?.toDouble() ?? 0,
      balanceUsagePercentage:
          (json['balance_usage_percentage'] as num?)?.toInt() ?? 0,
      targetCompletionPercentage:
          (json['target_completion_percentage'] as num?)?.toInt() ?? 0,
      isOverBudget: json['is_over_balance'] as bool? ?? false,
      isTargetAchieved: json['is_target_achieved'] as bool? ?? false,
      categoryBreakdown:
          (json['category_breakdown'] as List<dynamic>?)
              ?.map(
                (e) =>
                    CategorySpendingModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
      averageTransactionAmount:
          (json['average_transaction_amount'] as num?)?.toDouble() ?? 0,
      durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
      dailyAverageSpending:
          (json['daily_average_spending'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$FundReportModelToJson(_FundReportModel instance) =>
    <String, dynamic>{
      'fund_id': instance.fundId,
      'fund_name': instance.fundName,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'status': instance.status,
      'balance': instance.balance,
      'target': instance.target,
      'total_spent': instance.totalSpent,
      'remaining_balance': instance.remainingBudget,
      'balance_usage_percentage': instance.balanceUsagePercentage,
      'target_completion_percentage': instance.targetCompletionPercentage,
      'is_over_balance': instance.isOverBudget,
      'is_target_achieved': instance.isTargetAchieved,
      'category_breakdown': instance.categoryBreakdown,
      'total_transactions': instance.totalTransactions,
      'average_transaction_amount': instance.averageTransactionAmount,
      'duration_days': instance.durationDays,
      'daily_average_spending': instance.dailyAverageSpending,
    };
