import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/statistics/presentation/widgets/tag_item.dart';

class StatisticalWidgets extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String totalAmount;
  final List<CategoryEntity> categories;

  const StatisticalWidgets({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.text5,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfo(),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      centerSpaceRadius: 25,
                      sectionsSpace: 2,
                      sections:
                          categories
                              .map(
                                (e) => PieChartSectionData(
                                  color: e.color,
                                  value: e.percentage.toDouble(),
                                  title: '',
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),
            const Divider(),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                mainAxisExtent: 38,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return TagItem(category: categories[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppTexts.statisticsTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '$startDate - $endDate',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          totalAmount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}
