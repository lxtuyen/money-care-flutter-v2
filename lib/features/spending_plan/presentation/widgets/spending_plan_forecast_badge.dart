import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';

class SpendingPlanForecastBadge extends StatelessWidget {
  const SpendingPlanForecastBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final SpendingPlanController controller =
        Get.find<SpendingPlanController>();

    return Obx(() {
      final activePlan = controller.activePlan.value;
      final stats = controller.statsSummary.value;

      if (activePlan == null || stats == null) {
        return const SizedBox.shrink();
      }

      final projectedEndBalance = stats.projectedEndBalance;
      final isPositive = projectedEndBalance >= 0;
      final badgeColor = AppColors.primary;
      final formattedBalance = AppHelperFunction.formatCompactNumber(
        projectedEndBalance.abs(),
      );

      return GestureDetector(
        onTap: () {
          Get.toNamed(RoutePath.spendingPlanDetail, arguments: activePlan.id);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withOpacity(0.15), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: badgeColor,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                '${isPositive ? '+' : '-'}$formattedBalanceđ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: badgeColor,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                'cuối tháng',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: badgeColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
