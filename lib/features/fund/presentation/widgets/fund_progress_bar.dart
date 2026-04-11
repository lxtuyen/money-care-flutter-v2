import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/controllers/fund_controller.dart';

class FundProgressBar extends StatelessWidget {
  const FundProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FundController>();

    return Obx(() {
      final fund = controller.currentFund.value;
      final report = controller.fundReport.value;

      if (fund == null || report == null || controller.isLoadingReport.value) {
        return const SizedBox.shrink();
      }

      final double progress = (report.targetCompletionPercentage / 100).clamp(0.0, 1.0);
      final int percent = report.targetCompletionPercentage;
      
      const Color color = Color(0xFF4CAF50);

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: AppSizes.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
          border: Border.all(color: color.withOpacity(0.25), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars_rounded, size: 14, color: color),
                    const SizedBox(width: 6),
                    Text(
                      'Tiến độ: ${fund.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.text4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeSm,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: color.withOpacity(0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mục tiêu: ${AppHelperFunction.formatAmount(report.target, 'VNĐ')}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.text4,
                  ),
                ),
                if (report.isTargetAchieved)
                   const Text(
                    '🎉 Hoàn thành!',
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
