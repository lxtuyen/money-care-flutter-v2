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
  final double? limitLineY;
  final String? limitLineLabel;
  final List<FlSpot>? lineChartSpots;

  const AppBarChart({
    super.key,
    required this.barGroups,
    required this.getBottomTitles,
    this.tooltipData,
    this.maxY = 0,
    this.minY = 0,
    this.alignment = BarChartAlignment.spaceAround,
    this.groupsSpace,
    this.limitLineY,
    this.limitLineLabel,
    this.lineChartSpots,
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

    if (lineChartSpots != null) {
      for (var spot in lineChartSpots!) {
        if (spot.y > actualMaxY) {
          actualMaxY = spot.y;
        }
      }
    }

    double effectiveMaxY = maxY > 0 ? maxY : actualMaxY;
    if (limitLineY != null && limitLineY! > effectiveMaxY) {
      effectiveMaxY = limitLineY!;
    }
    if (effectiveMaxY == 0) effectiveMaxY = 10000;

    double interval = chartHelper.calculateInterval(effectiveMaxY);
    final roundedMaxY = (effectiveMaxY / interval).ceil() * interval;
    final chartMaxY = roundedMaxY + interval * 2;

    final extraLines = (limitLineY != null && limitLineY! > 0)
        ? ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: limitLineY!,
                color: const Color(0xFFFF5722),
                strokeWidth: 1.5,
                dashArray: [4, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  style: const TextStyle(
                    color: Color(0xFFFF5722),
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                  labelResolver: (line) => limitLineLabel ?? '',
                ),
              ),
            ],
          )
        : null;

    final titlesData = FlTitlesData(
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
          reservedSize: 32,
          interval: interval,
          getTitlesWidget: (value, meta) {
            if ((value - chartMaxY).abs() < epsilon) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
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
                overflow: TextOverflow.visible,
                softWrap: false,
              ),
            );
          },
        ),
      ),
    );

    final borderData = FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: AppColors.text4.withValues(alpha: 0.6),
          width: 1.8,
        ),
        left: BorderSide(
          color: AppColors.text4.withValues(alpha: 0.6),
          width: 1.8,
        ),
        top: BorderSide.none,
        right: BorderSide.none,
      ),
    );

    final gridData = FlGridData(
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
              ? AppColors.text4.withValues(alpha: 0.6)
              : AppColors.text4.withValues(alpha: 0.3),
          strokeWidth: isZeroLine ? 1.8 : 1,
          dashArray: isZeroLine ? null : const [4, 4],
        );
      },
    );

    return Stack(
      children: [
        BarChart(
          BarChartData(
            alignment: alignment,
            groupsSpace: groupsSpace,
            minY: minY,
            maxY: chartMaxY,
            extraLinesData: extraLines,
            gridData: gridData,
            borderData: borderData,
            titlesData: titlesData,
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
        ),
        if (lineChartSpots != null && lineChartSpots!.isNotEmpty)
          IgnorePointer(
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: chartMaxY,
                minX: 0,
                maxX: (barGroups.length > 1 ? barGroups.length - 1 : 1).toDouble(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.transparent, width: 1.8),
                    left: BorderSide(color: Colors.transparent, width: 1.8),
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
                      getTitlesWidget: (value, meta) => const SizedBox.shrink(),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: lineChartSpots!,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.warning,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    dashArray: [6, 4],
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.warning.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                lineTouchData: const LineTouchData(enabled: false),
              ),
            ),
          ),
      ],
    );
  }
}
