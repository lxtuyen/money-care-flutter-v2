import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class SpendingPlanBudgetSketchCard extends StatelessWidget {
  final double income;
  final double fixedExpense;
  final double flexibleAmount;
  final double fixedRatio;
  final double flexibleRatio;
  final List<EstimatedExpenseEntity> expenses;
  final double Function(EstimatedExpenseEntity expense) monthlyAmountFor;
  final void Function({int? index, EstimatedExpenseEntity? initial})
  onEditExpense;
  final ValueChanged<int> onRemoveExpense;

  const SpendingPlanBudgetSketchCard({
    super.key,
    required this.income,
    required this.fixedExpense,
    required this.flexibleAmount,
    required this.fixedRatio,
    required this.flexibleRatio,
    required this.expenses,
    required this.monthlyAmountFor,
    required this.onEditExpense,
    required this.onRemoveExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isOverBudget = income > 0 && flexibleAmount < 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phác họa ngân sách tháng',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 14),
          SpendingPlanBudgetAllocationBar(
            fixedRatio: fixedRatio,
            flexibleRatio: flexibleRatio,
            isOverBudget: isOverBudget,
          ),
          const SizedBox(height: 14),
          SpendingPlanAmountRow(
            label: 'Thu nhập hàng tháng',
            value: income,
          ),
          SpendingPlanAmountRow(
            label: 'Tổng chi phí dự kiến',
            value: fixedExpense,
          ),
          SpendingPlanAmountRow(
            label: isOverBudget ? 'Số tiền đang thiếu' : 'Số dư',
            value: flexibleAmount.abs(),
            prefix: isOverBudget ? '-' : null,
          ),

          if (isOverBudget) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.18),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Chi phí đang vượt thu nhập. Vui lòng giảm bớt chi phí.',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (expenses.isNotEmpty) ...[
            const Divider(height: 28, thickness: 0.8),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Danh sách khoản chi chi tiết:',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.text2,
                ),
              ),
            ),
            ...expenses.asMap().entries.map(
              (entry) => SpendingPlanExpenseLine(
                expense: entry.value,
                monthlyAmount: monthlyAmountFor(entry.value),
                onEdit: () =>
                    onEditExpense(index: entry.key, initial: entry.value),
                onRemove: () => onRemoveExpense(entry.key),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SpendingPlanBudgetAllocationBar extends StatelessWidget {
  final double fixedRatio;
  final double flexibleRatio;
  final bool isOverBudget;

  const SpendingPlanBudgetAllocationBar({
    super.key,
    required this.fixedRatio,
    required this.flexibleRatio,
    required this.isOverBudget,
  });

  @override
  Widget build(BuildContext context) {
    final fixedFlex = (fixedRatio * 1000).round().clamp(0, 1000);
    final flexibleFlex = (flexibleRatio * 1000).round().clamp(0, 1000);
    final fixedPct = (fixedRatio * 100).toStringAsFixed(0);
    final flexPct = (flexibleRatio * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 14,
            child: Row(
              children: [
                if (fixedFlex > 0)
                  Expanded(
                    flex: fixedFlex,
                    child: Container(
                      color: isOverBudget
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                  ),
                if (flexibleFlex > 0)
                  Expanded(
                    flex: flexibleFlex,
                    child: Container(color: Colors.grey.shade200),
                  ),
                if (fixedFlex == 0 && flexibleFlex == 0)
                  Expanded(child: Container(color: Colors.grey.shade200)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SpendingPlanAmountRow extends StatelessWidget {
  final String label;
  final double value;
  final String? prefix;

  const SpendingPlanAmountRow({
    super.key,
    required this.label,
    required this.value,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.text2,
              ),
            ),
          ),
          Text(
            '${prefix ?? ''}${AppHelperFunction.formatAmount(value)}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingPlanExpenseLine extends StatelessWidget {
  final EstimatedExpenseEntity expense;
  final double monthlyAmount;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const SpendingPlanExpenseLine({
    super.key,
    required this.expense,
    required this.monthlyAmount,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<UserCategoryController>();
    CategoryEntity? categoryEntity;
    if (expense.categoryId != null) {
      categoryEntity = categoryController.categories.firstWhereOrNull(
        (c) => c.id == expense.categoryId,
      );
    } else if (expense.category != null) {
      final norm = expense.category!.toLowerCase().trim();
      categoryEntity = categoryController.categories.firstWhereOrNull(
        (c) => c.name.toLowerCase().trim() == norm,
      );
    }

    final hasIcon = categoryEntity != null && categoryEntity.icon.isNotEmpty;
    final iconColor = categoryEntity?.color ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: hasIcon
                  ? AppSvgIcon(
                      iconName: categoryEntity.icon,
                      color: iconColor,
                      size: 18,
                    )
                  : const Icon(
                      Icons.receipt_long_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category ?? 'Khoản chi',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_frequencyLabel(expense)} - ${AppHelperFunction.formatAmount(monthlyAmount)}/tháng',
                  style: const TextStyle(fontSize: 11, color: AppColors.text3),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: Colors.blueAccent,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onRemove,
            icon: const Icon(
              Icons.close_rounded,
              size: 16,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  String _frequencyLabel(EstimatedExpenseEntity expense) {
    switch (expense.frequencyType) {
      case 'daily':
        return '${expense.frequencyValue} lần/ngày';
      case 'weekly':
        return '${expense.frequencyValue} lần/tuần';
      case 'monthly':
      default:
        return '${expense.frequencyValue} lần/tháng';
    }
  }
}
