import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/core/presentation/widgets/icon/rounded_icon.dart';

class SpendingOverviewCard extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final double amountSpent;
  final List<TotalByDateEntity> totals;

  const SpendingOverviewCard({
    super.key,
    required this.totals,
    this.startDate,
    this.endDate,
    required this.amountSpent,
  });

  double getNiceMaxY(double maxValue) {
    const step = 1000000;
    if (maxValue <= 0) return step.toDouble();
    return (((maxValue / step).ceil()) * step).toDouble();
  }

  List<DateTime> get dateRange {
    if (startDate == null || endDate == null) return [];
    final days = <DateTime>[];
    for (
      var d = startDate!;
      d.isBefore(endDate!.add(const Duration(days: 1)));
      d = d.add(const Duration(days: 1))
    ) {
      days.add(d);
    }
    return days;
  }

  String formatCurrencyShort(int value) {
    if (value >= 1000000) {
      double val = value / 1000000;
      if (val == val.roundToDouble()) {
        return '${val.toInt()}M';
      }
      return '${val.toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      double val = value / 1000;
      if (val == val.roundToDouble()) {
        return '${val.toInt()}K';
      }
      return '${val.toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final spendingData =
        dateRange.map((date) {
          final dayData = totals.firstWhere(
            (t) =>
                t.date.year == date.year &&
                t.date.month == date.month &&
                t.date.day == date.day,
            orElse: () => TotalByDateEntity(date: date, total: 0),
          );

          final value = dayData.total;
          return value < 0 ? 0.0 : value;
        }).toList();

    final double maxValue = 0;
        //spendingData.isEmpty ? 0 : spendingData.reduce((a, b) => a > b ? a : b);

    final double niceMaxY = getNiceMaxY(maxValue);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppHelperFunction.formatAmount(amountSpent.toDouble(), 'VND'),
                  style: const TextStyle(
                    fontSize: AppSizes.lg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text1,
                  ),
                ),
                RoundedIcon(
                  borderRadius: AppSizes.sm,
                  applyIconRadius: true,
                  padding: const EdgeInsets.all(8),
                  width: 36,
                  height: 36,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  iconPath: AppIcons.analysis,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Sá»‘ tiá»n Ä‘Ã£ chi tiÃªu trong khoáº£ng thá»i gian Ä‘Ã£ chá»n',
              style: TextStyle(color: AppColors.text4),
            ),
            const SizedBox(height: AppSizes.spaceBtwItems),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: niceMaxY,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < dateRange.length) {
                            final date = dateRange[index];
                            final label = AppHelperFunction.formatDayMonth(
                              date,
                            );
                            return Text(
                              label,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.text4,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            formatCurrencyShort(value.toInt()),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.text4,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        spendingData.length,
                        (i) => FlSpot(i.toDouble(), 8 /*spendingData[i]*/),
                      ),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => AppColors.primary,
                      tooltipBorderRadius: BorderRadius.circular(8.0),
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((barSpot) {
                          return LineTooltipItem(
                            "${AppHelperFunction.getFormattedDate(dateRange[barSpot.x.toInt()])}\n${AppHelperFunction.formatAmount(barSpot.y, 'VND')}",
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}