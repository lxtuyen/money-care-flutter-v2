import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final int percentage;
  final String icon;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.title,
    required this.percentage,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppThemeColors.of(context).cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withOpacity(0.42)
              : AppColors.borderSecondary,
          width: isSelected ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.of(context).textPrimary.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.16)
                      : AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: AppSvgIcon(
                    iconName: icon,
                    color: isSelected
                        ? AppColors.primary
                        : AppThemeColors.of(context).textSecondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isSelected
                  ? AppColors.primary
                  : AppThemeColors.of(context).textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
