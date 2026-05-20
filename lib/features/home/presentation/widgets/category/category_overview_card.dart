import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class CategoryOverviewCard extends StatelessWidget {
  final String title;
  final int spent;
  final String iconPath;
  final bool isIncome;
  final bool isBalanceVisible;

  const CategoryOverviewCard({
    super.key,
    required this.title,
    required this.spent,
    required this.iconPath,
    this.isIncome = false,
    this.isBalanceVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final String spentText = AppHelperFunction.formatAmount(
      spent.toDouble(),
      currency: 'VND',
    );

    Color themeColor = isIncome ? AppColors.income : AppColors.expense;

    final String spentLabel = isIncome ? "Đã nhận:" : "Đã tiêu:";

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppThemeColors.of(context).cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSecondary.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.text1.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              iconPath, // This is likely the emoji string in this context
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: AppSizes.spaceBtwItems),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spentLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text4,
                      ),
                    ),
                    Text(
                      '${isIncome ? '+' : '-'} $spentText',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
