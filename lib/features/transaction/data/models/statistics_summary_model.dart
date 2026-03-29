import 'package:money_care/features/transaction/domain/entities/statistics_summary_entity.dart';

class StatisticsSummaryModel extends StatisticsSummaryEntity {
  StatisticsSummaryModel({
    required super.dailyAverage,
    required super.dailyAverageChange,
    required super.dailyIncomeChange,
    required super.monthlyBalance,
  });

  factory StatisticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return StatisticsSummaryModel(
      dailyAverage: (json['dailyAverage'] as num).toDouble(),
      dailyAverageChange: (json['dailyAverageChange'] as num).toDouble(),
      dailyIncomeChange: (json['dailyIncomeChange'] as num).toDouble(),
      monthlyBalance: (json['monthlyBalance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyAverage': dailyAverage,
      'dailyAverageChange': dailyAverageChange,
      'dailyIncomeChange': dailyIncomeChange,
      'monthlyBalance': monthlyBalance,
    };
  }
}
