import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class SpendingSummary extends StatelessWidget {
  const SpendingSummary({
    super.key,
    required this.incomeTotal,
    required this.expenseTotal,
    this.isBalanceVisible = true,
    this.onToggleVisibility,
    this.onPressed,
  });

  final int incomeTotal;
  final int expenseTotal;
  final bool isBalanceVisible;
  final VoidCallback? onToggleVisibility;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final balance = incomeTotal - expenseTotal;
    final maskedText = '********';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = AppThemeColors.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A3A) : const Color(0xFFEFF7FF),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'home.spentInMonth'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppThemeColors.of(context).textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onToggleVisibility,
                      child: Icon(
                        isBalanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: themeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onPressed,
                  child: Row(
                    children: [
                      Text(
                        'common.viewDetail'.tr,
                        style: TextStyle(color: themeColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: themeColors.textSecondary,
                        size: AppSizes.md,
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  child: AppSvgIcon(
                    assetPath: AppIcons.chart2,
                    width: 150,
                    height: 70,
                  ),
                ),
              ],
            ),
          ),
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(AppSizes.borderRadiusLg),
              dashPattern: const [6, 3],
              color: AppThemeColors.of(context).textSecondary,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
              decoration: BoxDecoration(
                color: themeColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isBalanceVisible
                          ? AppHelperFunction.formatAmount(
                              expenseTotal.toDouble(),
                              '',
                            )
                          : maskedText,
                      style: const TextStyle(
                        color: AppColors.secondaryOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isBalanceVisible
                          ? '${'home.balance'.tr}: ${AppHelperFunction.formatAmount(AppHelperFunction.clampZero(balance).toDouble(), 'VND')}'
                          : '${'home.balance'.tr}: $maskedText',
                      style: const TextStyle(
                        color: AppColors.text3,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
