import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class StreakWeekdayRow extends StatelessWidget {
  const StreakWeekdayRow({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = [
      'streak.mon'.tr,
      'streak.tue'.tr,
      'streak.wed'.tr,
      'streak.thu'.tr,
      'streak.fri'.tr,
      'streak.sat'.tr,
      'streak.sun'.tr,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: labels
            .map(
              (label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppThemeColors.of(context).textSecondary,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
