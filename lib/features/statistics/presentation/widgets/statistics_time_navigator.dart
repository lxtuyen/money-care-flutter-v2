import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class StatisticsTimeNavigator extends StatelessWidget {
  const StatisticsTimeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final statisticsController = Get.find<StatisticsController>();

    return Obx(() {
      String label = "";
      if (statisticsController.periodType.value == 'hàng tháng') {
        label = AppHelperFunction.getFormattedDate(
          statisticsController.selectedMonth.value,
          format: 'yyyy/MM',
        );
      } else {
        label = AppHelperFunction.getFormattedDate(
          statisticsController.selectedDay.value,
          format: 'yyyy/MM/dd',
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildNavButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => statisticsController.previousPeriod(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (statisticsController.periodType.value == 'hàng ngày')
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              icon: Icons.chevron_right_rounded,
              onTap: () => statisticsController.nextPeriod(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
      ),
    );
  }
}
