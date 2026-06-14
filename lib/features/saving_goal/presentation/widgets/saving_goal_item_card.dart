import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/saving_goal_progress_bar.dart';

class SavingGoalItemCard extends StatelessWidget {
  final SavingGoalEntity fund;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback? onExtend;

  const SavingGoalItemCard({
    super.key,
    required this.fund,
    this.isSelected = false,
    required this.onTap,
    required this.onDelete,
    required this.onUpdate,
    this.onExtend,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSecondary,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildGoalIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              fund.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (fund.isCompleted) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.income.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Đã hoàn thành',
                                style: TextStyle(
                                  color: AppColors.income,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ] else if (fund.isExpired) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.expense.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Hết hạn',
                                style: const TextStyle(
                                  color: AppColors.expense,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tích lũy: ${AppHelperFunction.formatAmount(fund.savedAmount, currency: 'VND')} / ${AppHelperFunction.formatAmount(fund.target ?? 0, currency: 'VND')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.text3,
                        ),
                      ),
                      if (fund.wallet != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                fund.wallet!.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onUpdate();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    if (!fund.isCompleted)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Chỉnh sửa'),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bắt đầu: ${fund.startDate != null ? AppHelperFunction.getFormattedDate(fund.startDate!) : '-'}',
                  style: const TextStyle(fontSize: 11, color: AppColors.text4),
                ),
                Text(
                  fund.isCompleted
                      ? 'Hoàn thành: ${fund.updatedAt != null ? AppHelperFunction.getFormattedDate(fund.updatedAt!) : '-'}'
                      : 'Hạn: ${fund.endDate != null ? AppHelperFunction.getFormattedDate(fund.endDate!) : '-'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: fund.isCompleted
                        ? AppColors.income
                        : AppColors.text4,
                    fontWeight: fund.isCompleted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SavingGoalProgressBar(
              currentValue: fund.savedAmount,
              targetValue: fund.target ?? 0,
              showPercentage: true,
            ),
            if (onExtend != null && fund.isExpired && !fund.isCompleted) ...[
              const SizedBox(height: 12),
              PrimaryButton(label: 'Gia hạn mục tiêu', onPressed: onExtend),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoalIcon() {
    String emoji = '🎯';

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}
