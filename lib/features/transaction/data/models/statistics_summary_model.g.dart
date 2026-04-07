// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatisticsSummaryModelImpl _$$StatisticsSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$StatisticsSummaryModelImpl(
  dailyAverage: (json['dailyAverage'] as num).toDouble(),
  dailyAverageChange: (json['dailyAverageChange'] as num).toDouble(),
  dailyIncomeChange: (json['dailyIncomeChange'] as num).toDouble(),
  monthlyBalance: (json['monthlyBalance'] as num).toDouble(),
);

Map<String, dynamic> _$$StatisticsSummaryModelImplToJson(
  _$StatisticsSummaryModelImpl instance,
) => <String, dynamic>{
  'dailyAverage': instance.dailyAverage,
  'dailyAverageChange': instance.dailyAverageChange,
  'dailyIncomeChange': instance.dailyIncomeChange,
  'monthlyBalance': instance.monthlyBalance,
};
