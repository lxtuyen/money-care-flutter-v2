import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';

/// A premium card that compares current-period vs previous-period
/// income and expense, with animated change indicators.
class PeriodComparisonCard extends StatelessWidget {
  final int currentIncome;
  final int currentExpense;
  final int previousIncome;
  final int previousExpense;
  final String currentLabel;
  final String previousLabel;

  const PeriodComparisonCard({
    super.key,
    required this.currentIncome,
    required this.currentExpense,
    required this.previousIncome,
    required this.previousExpense,
    required this.currentLabel,
    required this.previousLabel,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final appController = Get.find<AppController>();

    return Obx(() {
      final isVisible = appController.isBalanceVisible.value;

      final incomeChange = _calcChange(previousIncome, currentIncome);
      final expenseChange = _calcChange(previousExpense, currentExpense);
      final currentBalance = currentIncome - currentExpense;
      final previousBalance = previousIncome - previousExpense;
      final balanceChange = _calcChange(previousBalance, currentBalance);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: themeColors.cardBackground,
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
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.compare_arrows_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'comparison.title'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: themeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: themeColors.textMuted,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        previousLabel,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: themeColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Text(
                        currentLabel,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 52,
                      child: Text(
                        'comparison.change'.tr,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: themeColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, indent: 16, endIndent: 16),

              // Income row
              _buildComparisonRow(
                icon: Icons.arrow_downward_rounded,
                iconColor: const Color(0xFF43A047),
                label: 'comparison.income'.tr,
                previousValue: previousIncome,
                currentValue: currentIncome,
                changePercent: incomeChange,
                isPositiveGood: true,
                isVisible: isVisible,
                themeColors: themeColors,
              ),

              Divider(
                height: 1,
                indent: 56,
                endIndent: 16,
                color: themeColors.borderSecondary,
              ),

              // Expense row
              _buildComparisonRow(
                icon: Icons.arrow_upward_rounded,
                iconColor: const Color(0xFFE53935),
                label: 'comparison.expense'.tr,
                previousValue: previousExpense,
                currentValue: currentExpense,
                changePercent: expenseChange,
                isPositiveGood: false,
                isVisible: isVisible,
                themeColors: themeColors,
              ),

              Divider(
                height: 1,
                indent: 56,
                endIndent: 16,
                color: themeColors.borderSecondary,
              ),

              // Balance row
              _buildComparisonRow(
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.primary,
                label: 'comparison.balance'.tr,
                previousValue: previousBalance,
                currentValue: currentBalance,
                changePercent: balanceChange,
                isPositiveGood: true,
                isVisible: isVisible,
                themeColors: themeColors,
                isBold: true,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildComparisonRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int previousValue,
    required int currentValue,
    required double changePercent,
    required bool isPositiveGood,
    required bool isVisible,
    required AppThemeColors themeColors,
    bool isBold = false,
  }) {
    final bool isUp = changePercent > 0;
    final bool isNeutral = changePercent == 0;
    final bool isGood = isNeutral
        ? true
        : (isPositiveGood ? isUp : !isUp);

    final Color changeColor = isNeutral
        ? themeColors.textMuted
        : (isGood ? const Color(0xFF43A047) : const Color(0xFFE53935));

    final String maskedText = '••••••';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),

          // Label
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: themeColors.textPrimary,
              ),
            ),
          ),

          // Previous value
          Expanded(
            flex: 3,
            child: Text(
              isVisible
                  ? _formatCompact(previousValue)
                  : maskedText,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: themeColors.textMuted,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Current value
          Expanded(
            flex: 3,
            child: Text(
              isVisible
                  ? _formatCompact(currentValue)
                  : maskedText,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: themeColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Change badge
          SizedBox(
            width: 52,
            child: _buildChangeBadge(
              changePercent,
              changeColor,
              isNeutral,
              isUp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeBadge(
    double percent,
    Color color,
    bool isNeutral,
    bool isUp,
  ) {
    final String text = isNeutral
        ? '0%'
        : '${isUp ? '+' : ''}${percent.toStringAsFixed(0)}%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isNeutral)
            Icon(
              isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 10,
              color: color,
            ),
          if (!isNeutral) const SizedBox(width: 2),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompact(int value) {
    final abs = value.abs();
    final prefix = value < 0 ? '-' : '';
    if (abs >= 1000000000) {
      return '$prefix${(abs / 1000000000).toStringAsFixed(1)}B';
    } else if (abs >= 1000000) {
      return '$prefix${(abs / 1000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000) {
      return '$prefix${(abs / 1000).toStringAsFixed(0)}K';
    }
    return '$prefix$abs';
  }

  double _calcChange(int previous, int current) {
    if (previous == 0 && current == 0) return 0;
    if (previous == 0) return 100;
    return ((current - previous) / previous.abs()) * 100;
  }
}
