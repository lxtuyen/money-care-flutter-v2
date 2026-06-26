import 'package:flutter/material.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';

class FixedCostBudgetSection extends StatefulWidget {
  final FixedCostBudgetModel fixedCostBudget;

  const FixedCostBudgetSection({super.key, required this.fixedCostBudget});

  @override
  State<FixedCostBudgetSection> createState() => _FixedCostBudgetSectionState();
}

class _FixedCostBudgetSectionState extends State<FixedCostBudgetSection> {
  final Set<String> _expandedCategories = {};

  void _toggleExpand(String categoryName) {
    setState(() {
      if (_expandedCategories.contains(categoryName)) {
        _expandedCategories.remove(categoryName);
      } else {
        _expandedCategories.add(categoryName);
      }
    });
  }

  String _formatFrequency(String freq) {
    switch (freq.toLowerCase()) {
      case 'weekly':
        return 'Tuần';
      case 'bi_weekly':
        return '2 tuần';
      case 'monthly':
      default:
        return 'Tháng';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final totalFixedCost = widget.fixedCostBudget.totalFixedCost;
    final categories = widget.fixedCostBudget.categories;

    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.repeat_on_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Chi phí cố định (Từ CSDL)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppHelperFunction.formatAmount(totalFixedCost),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...categories.map((category) {
          final isExpanded = _expandedCategories.contains(category.categoryName);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: colors.surfaceBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.borderSecondary, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Header Tile
                InkWell(
                  onTap: () => _toggleExpand(category.categoryName),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            category.categoryName,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              AppHelperFunction.formatAmount(category.totalAmount),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: colors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Expandable Details Section
                if (isExpanded) ...[
                  const Divider(height: 1, thickness: 0.6),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: category.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.description.isNotEmpty
                                      ? item.description
                                      : category.categoryName,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: colors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    AppHelperFunction.formatAmount(item.amount),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '/${_formatFrequency(item.frequency)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
