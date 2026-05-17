import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class FixedExpenseItem extends StatelessWidget {
  final FixedExpenseEntity expense;
  final VoidCallback? onTap;
  final bool isShowDivider;

  const FixedExpenseItem({
    super.key,
    required this.expense,
    this.onTap,
    this.isShowDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = expense.isPaid ? AppColors.income : AppColors.expense;
    final amountText =
        '- ${AppHelperFunction.formatAmount(expense.amount, currency: '')} ₫';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _categoryIcon(),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.name,
                        style: TextStyle(
                          fontSize: AppSizes.fontSizeSm + 1,
                          fontWeight: FontWeight.w600,
                          color: AppThemeColors.of(context).textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemeColors.of(context).textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amountText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                    Text(
                      expense.isPaid ? 'Đã thanh toán' : _dueText(),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppThemeColors.of(context).textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (isShowDivider)
            const Divider(
              color: AppColors.borderSecondary,
              height: AppSizes.dividerHeight,
              indent: 56,
            ),
        ],
      ),
    );
  }

  String _subtitle() {
    return [
      if (expense.category != null &&
          expense.category!.isNotEmpty &&
          expense.category!.toLowerCase() != expense.name.toLowerCase())
        expense.category,
      _frequencyText(),
    ].whereType<String>().where((item) => item.isNotEmpty).join(' · ');
  }

  String _frequencyText() {
    if (expense.frequencyType == 'once') return 'Một lần';
    return '${expense.frequencyValue} lần / ${_frequencyLabel(expense.frequencyType)}';
  }

  String _dueText() {
    if (expense.dueDay == null) return 'Chưa thanh toán';
    if (expense.frequencyType == 'weekly') {
      return 'Thứ ${_weekday(expense.dueDay)}';
    }
    return 'Ngày ${expense.dueDay}';
  }

  String _frequencyLabel(String type) {
    switch (type) {
      case 'daily':
        return 'ngày';
      case 'weekly':
        return 'tuần';
      case 'monthly':
        return 'tháng';
      default:
        return '';
    }
  }

  String _weekday(int? day) {
    if (day == null) return '';
    if (day == 7) return 'Chủ Nhật';
    return (day + 1).toString();
  }

  String _categoryIcon() {
    final catController = Get.find<UserCategoryController>();
    final catName = expense.category ?? expense.name;
    final category = catController.categories.firstWhereOrNull(
      (item) => item.name.toLowerCase() == catName.toLowerCase(),
    );
    return category?.icon ?? (expense.isPaid ? '✅' : '🧾');
  }
}
