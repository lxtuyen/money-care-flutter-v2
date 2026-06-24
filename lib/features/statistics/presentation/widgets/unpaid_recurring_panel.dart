import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';

class UnpaidRecurringPanel extends StatefulWidget {
  final List<UnpaidRecurringModel> items;

  const UnpaidRecurringPanel({super.key, required this.items});

  @override
  State<UnpaidRecurringPanel> createState() => _UnpaidRecurringPanelState();
}

class _UnpaidRecurringPanelState extends State<UnpaidRecurringPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final themeColors = AppThemeColors.of(context);
    final showAll = _expanded || widget.items.length <= 3;
    final displayItems = showAll ? widget.items : widget.items.take(3).toList();
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.expense.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.expense.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.expense,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Kho\u1EA3n c\u1ED1 \u0111\u1ECBnh ch\u01B0a thanh to\u00E1n (${widget.items.length})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.expense,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...displayItems.map((item) {
            final isOverdue =
                item.expectedDay != null && now.day > item.expectedDay!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: (isOverdue
                              ? AppColors.expense
                              : themeColors.textSecondary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isOverdue
                          ? Icons.error_outline
                          : Icons.schedule_rounded,
                      color: isOverdue
                          ? AppColors.expense
                          : themeColors.textSecondary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.description,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: themeColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.expectedDay != null
                              ? (isOverdue
                                  ? 'Qu\u00E1 h\u1EA1n (ng\u00E0y ${item.expectedDay})'
                                  : 'D\u1EF1 ki\u1EBFn ng\u00E0y ${item.expectedDay}')
                              : item.categoryName,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: isOverdue
                                        ? AppColors.expense
                                        : themeColors.textSecondary,
                                    fontWeight: isOverdue
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppHelperFunction.formatAmount(item.expectedAmount),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOverdue
                              ? AppColors.expense
                              : themeColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            );
          }),
          if (widget.items.length > 3)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Center(
                  child: Text(
                    _expanded
                        ? 'Thu g\u1ECDn'
                        : 'Xem th\u00EAm ${widget.items.length - 3} kho\u1EA3n',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
