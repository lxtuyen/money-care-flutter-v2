// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_goal_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneModel _$MilestoneModelFromJson(Map<String, dynamic> json) =>
    _MilestoneModel(
      label: json['label'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      target: (json['target'] as num?)?.toDouble() ?? 0,
      actual: (json['actual'] as num?)?.toDouble() ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
    );

Map<String, dynamic> _$MilestoneModelToJson(_MilestoneModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'target': instance.target,
      'actual': instance.actual,
      'is_completed': instance.isCompleted,
    };

_CategorySpendingModel _$CategorySpendingModelFromJson(
  Map<String, dynamic> json,
) => _CategorySpendingModel(
  categoryName: json['category_name'] as String,
  percentage: (json['percentage'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$CategorySpendingModelToJson(
  _CategorySpendingModel instance,
) => <String, dynamic>{
  'category_name': instance.categoryName,
  'percentage': instance.percentage,
  'total': instance.total,
};

_ProjectionModel _$ProjectionModelFromJson(Map<String, dynamic> json) =>
    _ProjectionModel(
      monthlySavingCapacity:
          (json['monthlySavingCapacity'] as num?)?.toDouble() ?? 0,
      monthsRemaining: (json['monthsRemaining'] as num?)?.toInt(),
      projectedDate: json['projectedDate'] == null
          ? null
          : DateTime.parse(json['projectedDate'] as String),
      isOnTrack: json['isOnTrack'] as bool?,
      monthsDiff: (json['monthsDiff'] as num?)?.toInt(),
      hasPlan: json['hasPlan'] as bool? ?? false,
    );

Map<String, dynamic> _$ProjectionModelToJson(_ProjectionModel instance) =>
    <String, dynamic>{
      'monthlySavingCapacity': instance.monthlySavingCapacity,
      'monthsRemaining': instance.monthsRemaining,
      'projectedDate': instance.projectedDate?.toIso8601String(),
      'isOnTrack': instance.isOnTrack,
      'monthsDiff': instance.monthsDiff,
      'hasPlan': instance.hasPlan,
    };

_SavingGoalReportModel _$SavingGoalReportModelFromJson(
  Map<String, dynamic> json,
) => _SavingGoalReportModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  target: (json['target'] as num?)?.toDouble() ?? 0,
  currentBalance: (json['current_balance'] as num?)?.toDouble() ?? 0,
  progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
  isCompleted: json['is_completed'] as bool? ?? false,
  completionNotified: json['completion_notified'] as bool? ?? false,
  currentMilestoneIndex:
      (json['current_milestone_index'] as num?)?.toInt() ?? -1,
  milestones:
      (json['milestones'] as List<dynamic>?)
          ?.map((e) => MilestoneModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  balanceUsagePercentage:
      (json['balanceUsagePercentage'] as num?)?.toInt() ?? 0,
  totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0,
  isOverBudget: json['isOverBudget'] as bool? ?? false,
  targetCompletionPercentage:
      (json['targetCompletionPercentage'] as num?)?.toInt() ?? 0,
  isTargetAchieved: json['isTargetAchieved'] as bool? ?? false,
  categoryBreakdown:
      (json['categoryBreakdown'] as List<dynamic>?)
          ?.map(
            (e) => CategorySpendingModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  totalTransactions: (json['totalTransactions'] as num?)?.toInt() ?? 0,
  dailyAverageSpending: (json['dailyAverageSpending'] as num?)?.toDouble() ?? 0,
  remainingBudget: (json['remainingBudget'] as num?)?.toDouble() ?? 0,
  walletName: json['wallet_name'] as String?,
  walletBalance: (json['wallet_balance'] as num?)?.toDouble() ?? 0,
  projection: json['projection'] == null
      ? null
      : ProjectionModel.fromJson(json['projection'] as Map<String, dynamic>),
  transactions:
      (json['transactions'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SavingGoalReportModelToJson(
  _SavingGoalReportModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'target': instance.target,
  'current_balance': instance.currentBalance,
  'progress_percent': instance.progressPercent,
  'is_completed': instance.isCompleted,
  'completion_notified': instance.completionNotified,
  'current_milestone_index': instance.currentMilestoneIndex,
  'milestones': instance.milestones,
  'balanceUsagePercentage': instance.balanceUsagePercentage,
  'totalSpent': instance.totalSpent,
  'isOverBudget': instance.isOverBudget,
  'targetCompletionPercentage': instance.targetCompletionPercentage,
  'isTargetAchieved': instance.isTargetAchieved,
  'categoryBreakdown': instance.categoryBreakdown,
  'totalTransactions': instance.totalTransactions,
  'dailyAverageSpending': instance.dailyAverageSpending,
  'remainingBudget': instance.remainingBudget,
  'wallet_name': instance.walletName,
  'wallet_balance': instance.walletBalance,
  'projection': instance.projection,
  'transactions': instance.transactions,
};
