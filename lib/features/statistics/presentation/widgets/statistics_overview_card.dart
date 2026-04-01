import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/statistics/presentation/widgets/category_share_chip.dart';

class StatisticsOverviewCard extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String totalAmount;
  final String incomeAmount;
  final List<CategoryEntity> categories;

  const StatisticsOverviewCard({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    this.incomeAmount = '0',
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasData = categories.isNotEmpty;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: title + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppTexts.statisticsTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$startDate - $endDate',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Pie chart + summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 110,
                  width: 110,
                  child: hasData
                      ? PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            centerSpaceRadius: 32,
                            sectionsSpace: 2,
                            sections: categories
                                .map(
                                  (e) => PieChartSectionData(
                                    color: e.color,
                                    value: e.percentage.toDouble(),
                                    title: '',
                                    radius: 22,
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.grey.shade200,
                                value: 1,
                                title: '',
                                radius: 22,
                              ),
                            ],
                            centerSpaceRadius: 32,
                            sectionsSpace: 0,
                          ),
                        ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountRow(
                        label: 'Chi tiêu',
                        amount: totalAmount,
                        color: AppColors.error,
                        icon: Icons.arrow_upward_rounded,
                      ),
                      const SizedBox(height: 10),
                      _buildAmountRow(
                        label: 'Thu nhập',
                        amount: incomeAmount,
                        color: AppColors.success,
                        icon: Icons.arrow_downward_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (hasData) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 38,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryShareChip(category: categories[index]);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
