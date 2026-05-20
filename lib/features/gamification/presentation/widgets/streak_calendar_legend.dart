import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class StreakCalendarLegend extends StatelessWidget {
  const StreakCalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(
            color: const Color(0xFFFFF3E0),
            borderColor: AppColors.secondaryOrange.withOpacity(0.12),
            label: 'streak.hasTransaction'.tr,
            icon: Icons.local_fire_department,
          ),
          const SizedBox(width: 24),
          _LegendItem(color: AppColors.primary, label: 'streak.today'.tr),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final String label;
  final IconData? icon;

  const _LegendItem({
    required this.color,
    required this.label,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.5)
                : null,
          ),
          child: icon != null
              ? Icon(icon, size: 13, color: AppColors.secondaryOrange)
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppThemeColors.of(context).textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
