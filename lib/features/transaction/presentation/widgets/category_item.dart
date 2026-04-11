import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';

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
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.42)
                  : AppColors.borderSecondary,
          width: isSelected ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.text1.withOpacity(0.04),
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
                  color:
                      isSelected
                          ? AppColors.primary.withOpacity(0.16)
                          : AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: AppSvgIcon(
                    iconName: icon,
                    color: isSelected ? AppColors.primary : AppColors.text4,
                    size: 22,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white.withOpacity(0.86)
                          : AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.text3,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
              color: isSelected ? AppColors.primary : AppColors.text2,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
