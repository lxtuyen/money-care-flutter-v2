import 'package:flutter/material.dart';
import 'package:money_care/features/home/presentation/widgets/budget_detail_dialog.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/app/widgets/icon/rounded_icon.dart';
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
    
    Color themeColor = isIncome ? AppColors.success : AppColors.error;
    if (!isIncome) {
      if (isNearLimit) themeColor = AppColors.warning;
      else if (isOverLimit) themeColor = AppColors.error;
    }
    
    final String spentLabel = isIncome ? "Đã nhận:" : "Đã tiêu:";
    final bool showLimit = limit > 0;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => BudgetDetailDialog(
          title: title,
          limit: limitText,
          spent: spentText,
          isOverLimit: isOverLimit,
          isIncome: isIncome,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
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
            // Category Icon (Matching TransactionItem)
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
                  if (showLimit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hạn mức:",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text4,
                          ),
                        ),
                        Text(
                          limitText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
                          fontWeight: FontWeight.w500,
                          color: AppColors.text4,
                        ),
                      ),
                      Text(
                        '${isIncome ? '+' : '-'} $spentText',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

