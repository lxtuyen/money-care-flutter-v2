// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatisticsSummaryModel _$StatisticsSummaryModelFromJson(
  Map<String, dynamic> json,
) => _StatisticsSummaryModel(
  dailyAverage: (json['dailyAverage'] as num).toDouble(),
  dailyAverageChange: (json['dailyAverageChange'] as num).toDouble(),
  dailyIncomeChange: (json['dailyIncomeChange'] as num).toDouble(),
  monthlyBalance: (json['monthlyBalance'] as num).toDouble(),
);

Map<String, dynamic> _$StatisticsSummaryModelToJson(
  _StatisticsSummaryModel instance,
) => <String, dynamic>{
  'dailyAverage': instance.dailyAverage,
  'dailyAverageChange': instance.dailyAverageChange,
  'dailyIncomeChange': instance.dailyIncomeChange,
  'monthlyBalance': instance.monthlyBalance,
};
