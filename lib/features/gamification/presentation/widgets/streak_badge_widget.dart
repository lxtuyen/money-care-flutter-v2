import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';

class StreakBadgeWidget extends StatelessWidget {
  const StreakBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GamificationController controller =
        Get.find<GamificationController>();

    return Obx(() {
      final streak = controller.currentStreak.value;
      if (streak <= 0) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () => Get.toNamed(RoutePath.streakCalendar),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondaryOrange.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '$streak',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryOrange,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                'ngày',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryOrange,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
