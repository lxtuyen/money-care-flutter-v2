import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/gamification/presentation/controllers/streak_calendar_controller.dart';

class StreakMonthHeader extends StatelessWidget {
  final StreakCalendarController controller;

  const StreakMonthHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final monthName = AppHelperFunction.getFormattedDate(
        controller.focusedMonth.value,
        format: 'MMMM yyyy',
        locale: Get.locale?.toString(),
      );

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: controller.prevMonth,
            ),
            Text(
              monthName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppThemeColors.of(context).textPrimary,
              ),
            ),
            _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: controller.nextMonth,
            ),
          ],
        ),
      );
    });
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppThemeColors.of(context).surfaceBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppThemeColors.of(context).textPrimary,
          size: 20,
        ),
      ),
    );
  }
}
