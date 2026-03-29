import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/presentation/widgets/chart/app_bar_chart.dart';

class SavingsBarChart extends StatelessWidget {
  final List<FlSpot> thisMonthSpots;
  final List<FlSpot> lastMonthSpots;
  final List<String> xLabels;

  const SavingsBarChart({
    super.key,
    required this.thisMonthSpots,
    required this.lastMonthSpots,
    required this.xLabels,
  });

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
    int maxLength = thisMonthSpots.length > lastMonthSpots.length
        ? thisMonthSpots.length
        : lastMonthSpots.length;

    for (int i = 0; i < maxLength; i++) {
      double thisVal = i < thisMonthSpots.length ? thisMonthSpots[i].y : 0;
      double lastVal = i < lastMonthSpots.length ? lastMonthSpots[i].y : 0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
              toY: thisVal,
              color: AppColors.secondaryOrange,
              width: 8,
              borderRadius: BorderRadius.circular(16),
            ),
            BarChartRodData(
              toY: lastVal,
              color: AppColors.secondaryNavyBlue,
              width: 8,
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendDot(AppColors.secondaryOrange, "Tháng này"),
            const SizedBox(width: 12),
            _buildLegendDot(AppColors.secondaryNavyBlue, "Tháng trước"),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          height: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),

          child: AppBarChart(
            minY: 0,
            getBottomTitles: (value, meta) {
              int index = value.round();
              if (index < 0 || index >= xLabels.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  xLabels[index],
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.text1,
                  ),
                ),
              );
            },
            tooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => AppColors.primary.withOpacity(0.8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  AppHelperFunction.formatAmount(rod.toY, 'VND'),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            barGroups: barGroups,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.text1),
        ),
      ],
    );
  }
}
