import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/transaction/domain/entities/statistics_summary_entity.dart';

part 'statistics_summary_model.freezed.dart';
part 'statistics_summary_model.g.dart';

@freezed
abstract class StatisticsSummaryModel with _$StatisticsSummaryModel {
  const factory StatisticsSummaryModel({
    required double dailyAverage,
    required double dailyAverageChange,
    required double dailyIncomeChange,
    required double monthlyBalance,
  }) = _StatisticsSummaryModel;

  const StatisticsSummaryModel._();

  factory StatisticsSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$StatisticsSummaryModelFromJson(json);

  StatisticsSummaryEntity toEntity() => StatisticsSummaryEntity(
        dailyAverage: dailyAverage,
        dailyAverageChange: dailyAverageChange,
        dailyIncomeChange: dailyIncomeChange,
        monthlyBalance: monthlyBalance,
      );
}


