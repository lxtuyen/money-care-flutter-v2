import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/statistics/presentation/widgets/category_share_chip.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class StatisticsOverviewCard extends StatefulWidget {
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
  State<StatisticsOverviewCard> createState() =>
      _StatisticsOverviewCardState();
}

class _StatisticsOverviewCardState extends State<StatisticsOverviewCard> {
  static const int _maxCollapsedItems = 4;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String displayTotal = widget.totalAmount;
    final String displayIncome = widget.incomeAmount;

    final bool hasData = widget.categories.isNotEmpty;
    final visibleCategories = _isExpanded
        ? widget.categories
        : widget.categories.take(_maxCollapsedItems).toList();
    final hiddenCount = widget.categories.length - _maxCollapsedItems;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppThemeColors.of(context).cardBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.startDate} - ${widget.endDate}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

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
                            sections: widget.categories
                                .map(
                                  (e) => PieChartSectionData(
                                    color: e.color,
                                    value: e.spendingPercentage,
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
                        amount: displayTotal,
                        color: AppColors.expense,
                        icon: Icons.arrow_downward_rounded,
                      ),
                      const SizedBox(height: 10),
                      _buildAmountRow(
                        label: 'Thu nhập',
                        amount: displayIncome,
                        color: AppColors.income,
                        icon: Icons.arrow_upward_rounded,
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
                itemCount: visibleCategories.length,
                itemBuilder: (context, index) {
                  return CategoryShareChip(category: visibleCategories[index]);
                },
              ),
              if (widget.categories.length > _maxCollapsedItems)
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded
                              ? 'Thu gọn'
                              : 'Xem thêm ($hiddenCount)',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
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
            color: color.withValues(alpha: 0.1),
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
