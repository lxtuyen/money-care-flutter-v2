import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class BudgetRecommendationMetrics extends StatelessWidget {
  final double proposedSavings;
  final double proposedSpend;
  final double forecastSavings;
  final double forecastSpend;

  const BudgetRecommendationMetrics({
    super.key,
    required this.proposedSavings,
    required this.proposedSpend,
    required this.forecastSavings,
    required this.forecastSpend,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildMetricTile(
              context,
              'Theo đề xuất',
              AppHelperFunction.formatAmount(proposedSavings),
              proposedSpend > 0
                  ? AppHelperFunction.formatAmount(proposedSpend)
                  : 'Chưa tính',
              AppColors.primary,
            ),
          ),
          _buildMetricDivider(context),
          Expanded(
            child: _buildMetricTile(
              context,
              'Theo dự báo',
              AppHelperFunction.formatAmount(forecastSavings),
              forecastSpend > 0
                  ? AppHelperFunction.formatAmount(forecastSpend)
                  : 'Chưa tính',
              AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricDivider(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return VerticalDivider(
      width: 16,
      thickness: 0.8,
      color: colors.textMuted.withValues(alpha: 0.2),
    );
  }

  Widget _buildMetricTile(
    BuildContext context,
    String label,
    String savingsValue,
    String spendValue,
    Color savingsColor,
  ) {
    final colors = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'T.kiệm:',
              style: TextStyle(fontSize: 9.5, color: colors.textMuted),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                savingsValue,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: savingsColor,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng chi:',
              style: TextStyle(fontSize: 9.5, color: colors.textMuted),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                spendValue,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
