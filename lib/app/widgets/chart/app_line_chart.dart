import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/chart_helper.dart';

class AppLineChart extends StatelessWidget {
  final List<LineChartBarData> lineBarsData;
  final Widget Function(double, TitleMeta) getBottomTitles;
  final LineTouchTooltipData? tooltipData;
  final double minY;
  final double? maxY;

  const AppLineChart({
    super.key,
    required this.lineBarsData,
    required this.getBottomTitles,
    this.tooltipData,
    this.minY = 0,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: false),
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
              getTitlesWidget: getBottomTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                return Text(
                  chartHelper.formatCurrencyShort(value.toInt()),
                  style: const TextStyle(fontSize: 10, color: AppColors.text4),
                );
              },
            ),
          ),
        ),
        lineBarsData: lineBarsData,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData:
              tooltipData ??
              LineTouchTooltipData(
                getTooltipColor: (_) => AppColors.primary,
                tooltipBorderRadius: BorderRadius.circular(8.0),
                fitInsideHorizontally: true,
                fitInsideVertically: true,
              ),
        ),
      ),
    );
  }
}
