import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/container/circular_container.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class CustomChoiceChip extends StatelessWidget {
  const CustomChoiceChip({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onSelected,
  });

  final String text;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final color = AppHelperFunction.getColor(text);
    final isColor = color != null;

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.text2,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        avatar: isColor
            ? Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.22)
                        : AppColors.borderSecondary,
                  ),
                ),
                child: Center(
                  child: AppCircularContainer(
                    height: 12,
                    width: 12,
                    backgroundColor: color,
                  ),
                ),
              )
            : null,
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withOpacity(0.12),
        surfaceTintColor: Colors.transparent,
        side: BorderSide(
          color: isSelected
              ? AppColors.primary.withOpacity(0.35)
              : AppColors.borderSecondary,
          width: isSelected ? 1.4 : 1,
        ),
        labelPadding: EdgeInsets.only(left: isColor ? 6 : 2, right: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        showCheckmark: false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
