import 'package:flutter/material.dart';
import 'package:money_care/features/home/presentation/widgets/balance_detail_dialog.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/presentation/widgets/icon/rounded_icon.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class SpendingLimitCard extends StatelessWidget {
  final String title;
  final double limit;
  final int spent;
  final String iconPath;

  const SpendingLimitCard({
    super.key,
    required this.title,
    required this.limit,
    required this.spent,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {

    String limitText = AppHelperFunction.formatAmount(limit, 'VND');
    String spentText = AppHelperFunction.formatAmount(spent.toDouble(), 'VND');
    bool isOverLimit = spent >= limit;
    return GestureDetector(
      onTap:
          () => showDialog(
            context: context,
            builder:
                (context) => BudgetDetailDialog(
                  title: title,
                  limit: limitText,
                  spent: spentText,
                  isOverLimit: isOverLimit,
                ),
          ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: AppSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
              color: AppColors.text4,
            ),
          ),
          const SizedBox(height: AppSizes.spaceBtwItems / 2),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                RoundedIcon(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  applyIconRadius: true,
                  width: 40,
                  height: 40,
                  backgroundColor: AppColors.backgroundSecondary,
                  iconName: iconPath,
                  size: AppSizes.lg,
                ),
                const SizedBox(width: AppSizes.spaceBtwItems),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hạn mức:",
                            style: TextStyle(
                              fontSize: AppSizes.fontSizeSm,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            limitText,
                            style: TextStyle(
                              fontSize: AppSizes.fontSizeSm,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Đã tiêu:",
                            style: TextStyle(
                              fontSize: AppSizes.fontSizeSm,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            spentText,
                            style: TextStyle(
                              fontSize: AppSizes.fontSizeSm,
                              fontWeight: FontWeight.w400,
                              color:
                                  isOverLimit
                                      ? AppColors.error
                                      : AppColors.success,
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
          const SizedBox(height: AppSizes.defaultSpace),
        ],
      ),
    );
  }
}
