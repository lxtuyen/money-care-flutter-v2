import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_care/core/constants/colors.dart';

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
      duration: const Duration(milliseconds: 200),
      width: 145,
      height: 105,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
          width: isSelected ? 3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/$icon.svg',
            color: isSelected ? AppColors.primary : Colors.grey,
            width: 28,
            height: 28,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            percentage.toString(),
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
