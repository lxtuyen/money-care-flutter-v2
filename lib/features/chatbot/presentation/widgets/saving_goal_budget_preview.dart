import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/models/saving_goal_proposal_model.dart';

class SavingGoalBudgetPreview extends StatelessWidget {
  final List<SavingGoalBudgetItem> items;
  final AppThemeColors colors;
  final double savingAmount;
  final double budgetTotal;
  final double totalAmount;
  final void Function(int, SavingGoalBudgetItem) onEdit;
  final void Function(int) onDelete;

  const SavingGoalBudgetPreview({
    super.key,
    required this.items,
    required this.colors,
    required this.savingAmount,
    required this.budgetTotal,
    required this.totalAmount,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceBackground.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.borderSecondary.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Ngân sách đề xuất',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _BudgetSummaryRow(
            label: 'Tổng tiền kế hoạch',
            amount: totalAmount,
            colors: colors,
            isStrong: true,
          ),
          const SizedBox(height: 6),
          _BudgetSummaryRow(
            label: 'Chi phí đề xuất',
            amount: budgetTotal,
            colors: colors,
          ),
          const SizedBox(height: 6),
          _BudgetSummaryRow(
            label: 'Tích lũy mục tiêu',
            amount: savingAmount,
            colors: colors,
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.borderSecondary.withValues(alpha: 0.65),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.categoryName,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppHelperFunction.formatAmount(item.monthlyLimit),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Chỉnh sửa',
                    onPressed: () => _showEditDialog(context, index, item),
                    icon: Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Xóa',
                    onPressed: () => onDelete(index),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 19,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    int index,
    SavingGoalBudgetItem item,
  ) {
    final controller = TextEditingController(
      text: item.monthlyLimit.toInt().toString(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            item.categoryName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Ngân sách/tháng',
              suffixText: 'đ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final rawAmount = controller.text.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                final amount = double.tryParse(rawAmount) ?? 0;

                onEdit(
                  index,
                  item.copyWith(amount: amount, monthlyLimit: amount),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}

class _BudgetSummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final AppThemeColors colors;
  final bool isStrong;

  const _BudgetSummaryRow({
    required this.label,
    required this.amount,
    required this.colors,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isStrong
            ? AppColors.primary.withValues(alpha: 0.08)
            : colors.surfaceBackground.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isStrong ? FontWeight.w800 : FontWeight.w600,
                color: isStrong ? AppColors.primary : colors.textSecondary,
              ),
            ),
          ),
          Text(
            AppHelperFunction.formatAmount(amount),
            style: TextStyle(
              fontSize: 12.2,
              fontWeight: FontWeight.w800,
              color: isStrong ? AppColors.primary : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
