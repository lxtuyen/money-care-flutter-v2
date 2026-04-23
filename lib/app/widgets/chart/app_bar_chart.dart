import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/chart_helper.dart';

class AppBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final Widget Function(double, TitleMeta) getBottomTitles;
  final BarTouchTooltipData? tooltipData;
  final double maxY;
  final double minY;
  final BarChartAlignment alignment;
  final double? groupsSpace;

  const AppBarChart({
    super.key,
    required this.barGroups,
    required this.getBottomTitles,
    this.tooltipData,
    this.maxY = 0,
    this.minY = 0,
    this.alignment = BarChartAlignment.spaceAround,
    this.groupsSpace,
  });

  @override
  Widget build(BuildContext context) {
    const epsilon = 0.0001;

    double actualMaxY = 0;
    for (var group in barGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > actualMaxY) {
          actualMaxY = rod.toY;
        }
      }
    }

    double effectiveMaxY = maxY > 0 ? maxY : actualMaxY;
    if (effectiveMaxY == 0) effectiveMaxY = 10000;

    double interval = chartHelper.calculateInterval(effectiveMaxY);
    final roundedMaxY = (effectiveMaxY / interval).ceil() * interval;
    final chartMaxY = roundedMaxY + interval * 2;

    return BarChart(
      BarChartData(
        alignment: alignment,
        groupsSpace: groupsSpace,
        minY: minY,
        maxY: chartMaxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          checkToShowHorizontalLine: (value) {
            return value >= minY && value <= chartMaxY;
          },
          getDrawingHorizontalLine: (value) {
            final isZeroLine = value.abs() < epsilon;
            final isMaxLine = (value - roundedMaxY).abs() < epsilon;

            return FlLine(
              color: (isZeroLine || isMaxLine)
                  ? AppColors.text4.withOpacity(0.6)
                  : AppColors.text4.withOpacity(0.3),
              strokeWidth: isZeroLine ? 1.8 : 1,
              dashArray: isZeroLine ? null : const [4, 4],
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: AppColors.text4.withOpacity(0.6),
              width: 1.8,
            ),
            left: BorderSide(
              color: AppColors.text4.withOpacity(0.6),
              width: 1.8,
            ),
            top: BorderSide.none,
            right: BorderSide.none,
          ),
        ),
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
              reservedSize: 24,
              getTitlesWidget: getBottomTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: interval,
              getTitlesWidget: (value, meta) {
                if ((value - chartMaxY).abs() < epsilon) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    chartHelper.formatCurrencyShort(value.toInt()),
                    style: TextStyle(
                      fontSize: 8,
                      color: value.abs() < epsilon
                          ? AppColors.text1
                          : AppColors.text4,
                      fontWeight: value.abs() < epsilon
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: barGroups,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData:
              tooltipData ??
              BarTouchTooltipData(
                getTooltipColor: (_) => AppColors.primary,
                tooltipBorderRadius: BorderRadius.circular(8.0),
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    chartHelper.formatCurrencyShort(rod.toY.toInt()),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
