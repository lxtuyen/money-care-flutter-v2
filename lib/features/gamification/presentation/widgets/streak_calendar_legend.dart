import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class StreakCalendarLegend extends StatelessWidget {
  const StreakCalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: const Color(0xFFFFF3E0),
                borderColor: AppColors.secondaryOrange.withValues(alpha: 0.12),
                label: 'streak.hasTransaction'.tr,
                icon: Icons.local_fire_department,
              ),
              const SizedBox(width: 20),
              _LegendItem(color: AppColors.primary, label: 'streak.today'.tr),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'streak.heatmapLegend'.tr,
            style: TextStyle(
              fontSize: 11,
              color: AppThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'streak.less'.tr,
                style: TextStyle(
                  fontSize: 11,
                  color: AppThemeColors.of(context).textSecondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 6),
              const _HeatBox(opacity: 0.15),
              const SizedBox(width: 4),
              const _HeatBox(opacity: 0.35),
              const SizedBox(width: 4),
              const _HeatBox(opacity: 0.60),
              const SizedBox(width: 4),
              const _HeatBox(opacity: 0.85),
              const SizedBox(width: 6),
              Text(
                'streak.more'.tr,
                style: TextStyle(
                  fontSize: 11,
                  color: AppThemeColors.of(context).textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatBox extends StatelessWidget {
  final double opacity;

  const _HeatBox({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: AppColors.secondaryOrange.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(4),
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
