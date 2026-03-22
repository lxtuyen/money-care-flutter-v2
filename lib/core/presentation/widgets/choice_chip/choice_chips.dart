import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/presentation/widgets/container/circular_container.dart';

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
            color: isSelected
                ? Colors.white
                : (isColor ? AppColors.text1 : null),
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        avatar: isColor
            ? AppCircularContainer(
                height: 20,
                width: 20,
                backgroundColor: color,
              )
            : null,
        backgroundColor: isSelected
            ? AppColors.buttonPrimary
            : AppColors.backgroundPrimary,
        selectedColor: AppColors.buttonPrimary,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.buttonPrimary
                : AppColors.borderPrimary,
          ),
        ),
      ),
    );
  }
}
