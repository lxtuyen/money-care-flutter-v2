import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/widgets/chart/app_bar_chart.dart';

class SavingsBarChart extends StatelessWidget {
  final List<FlSpot> thisMonthSpots;
  final List<FlSpot> lastMonthSpots;
  final List<String> xLabels;
  final bool isComparison;

  const SavingsBarChart({
    super.key,
    required this.thisMonthSpots,
    required this.lastMonthSpots,
    required this.xLabels,
    this.isComparison = true,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double leftTitlesReservedSize = 28.0;
    final double chartWidth = screenWidth - leftTitlesReservedSize - 16; 
    final double barWidth = (chartWidth / (xLabels.length * 1.5)).clamp(4.0, 16.0);
    final double barsSpace = (barWidth / 2).clamp(2.0, 4.0);

    final List<BarChartGroupData> barGroups = List.generate(xLabels.length, (index) {
      final List<BarChartRodData> rods = [];
      
      if (isComparison) {
        rods.add(
          BarChartRodData(
            toY: index < lastMonthSpots.length ? lastMonthSpots[index].y : 0,
            gradient: LinearGradient(
              colors: [
                Colors.grey.withOpacity(0.3),
                Colors.grey.withOpacity(0.5),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: barWidth,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        );
      }

      rods.add(
        BarChartRodData(
          toY: index < thisMonthSpots.length ? thisMonthSpots[index].y : 0,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.7),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: barWidth,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      );

      return BarChartGroupData(
        x: index,
        barRods: rods,
        barsSpace: barsSpace,
      );
    });

    return Column(
      children: [
        if (isComparison)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot(AppColors.primary, "Tháng này"),
              const SizedBox(width: 20),
              _buildLegendDot(Colors.grey.withOpacity(0.5), "Tháng trước"),
            ],
          ),
        if (isComparison) const SizedBox(height: 10),

        Container(
          height: 220,
          padding: const EdgeInsets.only(top: 12, right: 0, bottom: 12, left: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBarChart(
            minY: 0,
            alignment: BarChartAlignment.start,
            groupsSpace: (xLabels.length <= 1) ? 0 : ((chartWidth - (xLabels.length * barWidth * (isComparison ? 2 : 1))) / (xLabels.length - 1)).clamp(0.0, 30.0),
            getBottomTitles: (value, meta) {
              int index = value.round();
              if (index < 0 || index >= xLabels.length || xLabels[index].isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  xLabels[index],
                  style: TextStyle(
                    fontSize: xLabels.length > 24 ? 8 : 10,
                    color: AppColors.text1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
            tooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => AppColors.primary.withOpacity(0.9),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final controller = Get.find<StatisticsController>();
                String dateStr = "";
                
                if (controller.periodType.value == 'hàng tháng') {
                  final date = DateTime(
                    controller.selectedMonth.value.year,
                    controller.selectedMonth.value.month,
                    groupIndex + 1,
                  );
                  dateStr = DateFormat('yyyy/MM/dd').format(date);
                } else {
                  dateStr = "${DateFormat('yyyy/MM/dd').format(controller.selectedDay.value)} ${groupIndex.toString().padLeft(2, '0')}:00";
                }

                return BarTooltipItem(
                  "$dateStr\n",
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: AppHelperFunction.formatAmount(rod.toY, 'VND'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
