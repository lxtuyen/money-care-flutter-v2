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

class ExpenseTemplatesList extends StatelessWidget {
  final ValueChanged<CategoryEntity> onTapCategory;

  const ExpenseTemplatesList({super.key, required this.onTapCategory});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<UserCategoryController>();

    return Obx(() {
      final expenseCategories = categoryController.categories
          .where((cat) => cat.type != 'income')
          .toList();

      if (expenseCategories.isEmpty) {
        return const SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'Không có danh mục chi tiêu nào.',
              style: TextStyle(color: AppColors.text3, fontSize: 13),
            ),
          ),
        );
      }

      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: expenseCategories.length,
          itemBuilder: (context, idx) {
            final cat = expenseCategories[idx];
            final hasIcon = cat.icon.isNotEmpty;
            final iconColor = cat.color ?? AppColors.primary;

            return Container(
              width: 135,
              margin: const EdgeInsets.only(right: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSecondary),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onTapCategory(cat),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: hasIcon
                              ? AppSvgIcon(
                                  iconName: cat.icon,
                                  color: iconColor,
                                  size: 18,
                                )
                              : const Icon(
                                  Icons.receipt_long_outlined,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                        ),
                        const Spacer(),
                        Text(
                          cat.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
