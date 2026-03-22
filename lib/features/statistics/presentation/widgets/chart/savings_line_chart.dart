import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';

class SavingsLineChart extends StatelessWidget {
  final List<FlSpot> thisMonthSpots;
  final List<FlSpot> lastMonthSpots;
  final List<String> xLabels;

  const SavingsLineChart({
    super.key,
    required this.thisMonthSpots,
    required this.lastMonthSpots,
    required this.xLabels,
  });

  @override
  Widget build(BuildContext context) {
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

          child: LineChart(
            LineChartData(
              minY: 0,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),

              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget:
                        (value, meta) => Text(
                          formatCurrencyShort(value.toInt()),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.text1,
                          ),
                        ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
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
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor:
                      (value) => AppColors.primary.withOpacity(0.8),
                  getTooltipItems: (items) {
                    return items.map((item) {
                      return LineTooltipItem(
                        AppHelperFunction.formatAmount(
                          item.y,'VND'
                        ),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),

              lineBarsData: [
                _buildLine(AppColors.secondaryOrange, thisMonthSpots),
                _buildLine(AppColors.secondaryNavyBlue, lastMonthSpots),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildLine(Color color, List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.15)),
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
