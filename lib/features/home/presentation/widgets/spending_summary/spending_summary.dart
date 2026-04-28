import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7FF),
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
                    const Text(
                      'Số tiền bạn chi trong tháng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text2,
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
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onPressed,
                  child: Row(
                    children: const [
                      Text(
                        'Xem chi tiết',
                        style: TextStyle(color: AppColors.primary, fontSize: 14),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
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
              color: AppColors.text4,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.white,
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
                          ? 'Số dư: ${AppHelperFunction.formatAmount(AppHelperFunction.clampZero(balance).toDouble(), 'VND')}'
                          : 'Số dư: $maskedText',
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
