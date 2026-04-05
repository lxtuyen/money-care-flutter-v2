import 'package:flutter/material.dart';
import 'package:money_care/features/home/presentation/widgets/budget_detail_dialog.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/presentation/widgets/icon/rounded_icon.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class CategoryOverviewCard extends StatelessWidget {
  final String title;
  final double limit;
  final int spent;
  final String iconPath;
  final bool isIncome;

  const CategoryOverviewCard({
    super.key,
    required this.title,
    required this.limit,
    required this.spent,
    required this.iconPath,
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    final String limitText = AppHelperFunction.formatAmount(limit, 'VND');
    final String spentText = AppHelperFunction.formatAmount(spent.toDouble(), 'VND');
    final bool isOverLimit = limit > 0 && spent >= limit;
    final bool isNearLimit = limit > 0 && spent >= (limit * 0.8) && !isOverLimit;
    
    // Dynamic themes
    Color themeColor = isIncome ? AppColors.success : AppColors.primary;
    if (!isIncome) {
      if (isOverLimit) themeColor = AppColors.error;
      else if (isNearLimit) themeColor = Colors.orange; // Amber/Warning color
    }
    
    final String spentLabel = isIncome ? "ÄÃ£ nháº­n:" : "ÄÃ£ tiÃªu:";
    final bool showLimit = limit > 0;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => BudgetDetailDialog(
          title: title,
          limit: limitText,
          spent: spentText,
          isOverLimit: isOverLimit,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                RoundedIcon(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  applyIconRadius: true,
                  width: 44,
                  height: 44,
                  backgroundColor: themeColor.withOpacity(0.12),
                  iconName: iconPath,
                  color: themeColor,
                  size: 24,
                ),
                const SizedBox(width: AppSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (showLimit) 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Háº¡n má»©c:",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text3,
                              ),
                            ),
                            Text(
                              limitText,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            spentLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            spentText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isOverLimit ? AppColors.error : themeColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

