import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class EstimatedExpenseBudgetGroupCard extends StatelessWidget {
  final String categoryName;
  final int daysInMonth;
  final List<EstimatedExpenseEntity> expenses;
  final void Function(EstimatedExpenseEntity)? onExpenseTap;

  const EstimatedExpenseBudgetGroupCard({
    super.key,
    required this.categoryName,
    required this.daysInMonth,
    required this.expenses,
    this.onExpenseTap,
  });

  static Map<String, List<EstimatedExpenseEntity>> groupExpenses(
    List<EstimatedExpenseEntity> expenses,
  ) {
    final groups = <String, List<EstimatedExpenseEntity>>{};
    for (final expense in expenses) {
      final category = expense.category?.trim();
      final key = category != null && category.isNotEmpty
          ? category
          : expense.displayName;
      groups.putIfAbsent(key, () => []).add(expense);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final monthlyLimit = _totalMonthlyLimit;
    final spent = _totalSpent;
    final progress = monthlyLimit <= 0
        ? 0.0
        : (spent / monthlyLimit).clamp(0.0, 1.0);
    final progressPercent = progress * 100;
    final progressColor = spent > monthlyLimit
        ? AppColors.expense
        : progress >= 0.8
        ? const Color(0xFFF59E0B)
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _categoryIcon(),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: themeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatMoney(monthlyLimit),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: themeColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '/ tháng',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatMoney(spent)} / ${_formatMoney(monthlyLimit)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${progressPercent.toStringAsFixed(progressPercent % 1 == 0 ? 0 : 1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double get _totalMonthlyLimit {
    return expenses.fold(0.0, (total, expense) {
      return total + _monthlyLimitFor(expense);
    });
  }

  double get _totalSpent {
    return expenses.fold(0.0, (total, expense) {
      return total + expense.spentThisMonth;
    });
  }

  double _monthlyLimitFor(EstimatedExpenseEntity expense) {
    if (expense.monthlyLimit > 0) {
      return expense.monthlyLimit;
    }
    return _monthlyizedAmount(expense);
  }

  double _monthlyizedAmount(EstimatedExpenseEntity expense) {
    final frequencyValue = expense.frequencyValue <= 0
        ? 1
        : expense.frequencyValue;
    switch (expense.frequencyType.toLowerCase()) {
      case 'daily':
        return expense.amount * frequencyValue * daysInMonth;
      case 'weekly':
        return expense.amount * frequencyValue * (daysInMonth / 7);
      case 'monthly':
      case 'once':
      default:
        return expense.amount * frequencyValue;
    }
  }

  String _categoryIcon() {
    final catController = Get.find<UserCategoryController>();
    final category = catController.categories.firstWhereOrNull(
      (item) => item.name.toLowerCase() == categoryName.toLowerCase(),
    );
    return category?.icon ?? '';
  }

  String _formatMoney(double value) {
    return AppHelperFunction.formatAmount(value);
  }
}
