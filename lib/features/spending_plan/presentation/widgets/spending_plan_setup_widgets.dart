import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class IncomeChoice {
  final String label;
  final double amount;

  const IncomeChoice(this.label, this.amount);
}

class IncomeQuickChips extends StatelessWidget {
  final double selectedAmount;
  final ValueChanged<double> onSelected;
  final List<IncomeChoice> choices;

  const IncomeQuickChips({
    super.key,
    required this.selectedAmount,
    required this.onSelected,
    this.choices = const [
      IncomeChoice('3 triệu', 3000000),
      IncomeChoice('5 triệu', 5000000),
      IncomeChoice('10 triệu', 10000000),
      IncomeChoice('15 triệu', 15000000),
      IncomeChoice('20 triệu', 20000000),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: choices.map((choice) {
        final isSelected = selectedAmount == choice.amount;
        return ChoiceChip(
          label: Text(choice.label),
          selected: isSelected,
          showCheckmark: false,
          onSelected: (_) => onSelected(choice.amount),
          selectedColor: AppColors.primary.withValues(alpha: 0.12),
          backgroundColor: Colors.grey.shade50,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.primary : AppColors.text2,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.borderSecondary,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }
}

class ExpenseCategoryChips extends StatelessWidget {
  final ValueChanged<CategoryEntity> onTapCategory;
  final Set<int?> selectedCategoryIds;

  const ExpenseCategoryChips({
    super.key,
    required this.onTapCategory,
    this.selectedCategoryIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<UserCategoryController>();

    return Obx(() {
      final expenseCategories = categoryController.categories
          .where((cat) => cat.type != 'income')
          .toList();

      if (expenseCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: expenseCategories.map((cat) {
          final isSelected = selectedCategoryIds.contains(cat.id);
          final hasIcon = cat.icon.isNotEmpty;
          final iconColor = isSelected
              ? Colors.grey.shade400
              : (cat.color ?? AppColors.primary);

          return InkWell(
            onTap: isSelected ? null : () => onTapCategory(cat),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.grey.shade100
                    : iconColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.grey.shade300
                      : iconColor.withValues(alpha: 0.22),
                  width: 1.1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasIcon) ...[
                    AppSvgIcon(iconName: cat.icon, color: iconColor, size: 14),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.grey.shade400
                          : iconColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
