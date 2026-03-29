import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/presentation/widgets/chart/app_bar_chart.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

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

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppHelperFunction.formatAmount(amountSpent.toDouble(), 'VND'),
              style: const TextStyle(
                fontSize: AppSizes.lg,
                fontWeight: FontWeight.bold,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Số tiền đã chi tiêu trong 7 ngày gần đây',
              style: TextStyle(color: AppColors.text4),
            ),
            const SizedBox(height: AppSizes.spaceBtwItems),
            SizedBox(
              height: 220,
              child: AppBarChart(
                minY: 0,
                getBottomTitles: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < dateRange.length) {
                    final date = dateRange[index];
                    final label = AppHelperFunction.formatDayMonth(date);
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
                barGroups: List.generate(
                  spendingData.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
  toY: spendingData[i].toDouble(),
  gradient: LinearGradient(
    colors: [
      AppColors.primary,
      AppColors.primary.withOpacity(0.6),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  ),
  width: 16,
  borderRadius: BorderRadius.circular(8),
),
                    ],
                  ),
                ),
                tooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColors.primary,
                  tooltipBorderRadius: BorderRadius.circular(16),
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      "${AppHelperFunction.getFormattedDate(dateRange[group.x.toInt()])}\n${AppHelperFunction.formatAmount(rod.toY, 'VND')}",
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
