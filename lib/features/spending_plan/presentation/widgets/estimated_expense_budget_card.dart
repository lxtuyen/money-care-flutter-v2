import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class EstimatedExpenseBudgetCard extends StatelessWidget {
  final int daysInMonth;
  final EstimatedExpenseEntity expense;
  final VoidCallback? onTap;

  const EstimatedExpenseBudgetCard({
    super.key,
    required this.daysInMonth,
    required this.expense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final monthlyLimit = _monthlyLimit;
    final spent = expense.spentThisMonth;
    final progressPercent = _progressPercent(monthlyLimit);
    final progressValue = (progressPercent / 100).clamp(0.0, 1.0);
    final progressColor = _progressColor(progressPercent);
    final overAmount = spent - monthlyLimit;
    final categoryName = _categoryName;
    final subCategoryName = _subCategoryName;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
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
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppThemeColors.of(context).textPrimary,
                              ),
                        ),
                        if (subCategoryName != null) ...[
                          const SizedBox(height: 4),
                          _SubCategoryLine(name: subCategoryName),
                        ],
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
                          color: AppThemeColors.of(context).textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '/ th\u00e1ng',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppThemeColors.of(context).textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _formulaText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppThemeColors.of(context).textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progressValue,
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
                        color: AppThemeColors.of(context).textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    overAmount > 0
                        ? 'V\u01b0\u1ee3t ${_formatMoney(overAmount)}'
                        : '${progressPercent.toStringAsFixed(progressPercent % 1 == 0 ? 0 : 1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              if (_dailyLimit > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '${_formatMoney(expense.todaySpent)} / ${_formatMoney(_dailyLimit)} h\u00f4m nay',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: expense.dailyOverAmount > 0
                        ? AppColors.expense
                        : AppThemeColors.of(context).textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String get _categoryName {
    final category = expense.category?.trim();
    if (category != null && category.isNotEmpty) return category;
    return expense.displayName;
  }

  String? get _subCategoryName {
    final subCategory = expense.subCategory?.trim();
    if (subCategory == null || subCategory.isEmpty) return null;
    return subCategory;
  }

  int get _daysInMonth => daysInMonth;

  double get _monthlyLimit {
    if (expense.monthlyLimit > 0) return expense.monthlyLimit;
    return _monthlyizedAmount;
  }

  double get _dailyLimit {
    if (expense.dailyLimit != null && expense.dailyLimit! > 0) {
      return expense.dailyLimit!;
    }
    if (expense.frequencyType == 'daily') {
      return expense.amount * expense.frequencyValue;
    }
    return 0;
  }

  double get _monthlyizedAmount {
    final amount = expense.amount;
    final frequencyValue = expense.frequencyValue <= 0
        ? 1
        : expense.frequencyValue;
    switch (expense.frequencyType) {
      case 'daily':
        return amount * frequencyValue * _daysInMonth;
      case 'weekly':
        return amount * frequencyValue * (_daysInMonth / 7);
      case 'monthly':
      case 'once':
      default:
        return amount * frequencyValue;
    }
  }

  double _progressPercent(double monthlyLimit) {
    if (expense.monthlyProgress > 0) return expense.monthlyProgress;
    if (monthlyLimit <= 0) return 0;
    return (expense.spentThisMonth / monthlyLimit) * 100;
  }

  Color _progressColor(double progressPercent) {
    if (progressPercent >= 100) return AppColors.expense;
    if (progressPercent >= 80) return const Color(0xFFF59E0B);
    return AppColors.primary;
  }

  String get _formulaText {
    final amount = _formatMoney(expense.amount);
    final frequencyValue = expense.frequencyValue <= 0
        ? 1
        : expense.frequencyValue;
    switch (expense.frequencyType) {
      case 'daily':
        return '$amount x $frequencyValue l\u1ea7n/ng\u00e0y x $_daysInMonth ng\u00e0y';
      case 'weekly':
        return '$amount x $frequencyValue l\u1ea7n/tu\u1ea7n x ${(_daysInMonth / 7).toStringAsFixed(2)} tu\u1ea7n';
      case 'monthly':
        return '$amount x $frequencyValue l\u1ea7n/th\u00e1ng';
      case 'once':
      default:
        return '$amount x $frequencyValue l\u1ea7n';
    }
  }

  String _categoryIcon() {
    final catController = Get.find<UserCategoryController>();
    final category = catController.categories.firstWhereOrNull(
      (item) => item.name.toLowerCase() == _categoryName.toLowerCase(),
    );
    return category?.icon ?? '\u{1F9FE}';
  }

  String _formatMoney(double value) {
    return '${NumberFormat('#,###', 'vi_VN').format(value)}\u0111';
  }
}

class _SubCategoryLine extends StatelessWidget {
  final String name;

  const _SubCategoryLine({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppThemeColors.of(context).textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
