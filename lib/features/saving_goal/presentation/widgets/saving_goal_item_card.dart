import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/saving_goal_progress_bar.dart';

class SavingGoalItemCard extends StatelessWidget {
  final SavingGoalEntity fund;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const SavingGoalItemCard({
    super.key,
    required this.fund,
    this.isSelected = false,
    required this.onTap,
    required this.onDelete,
    required this.onUpdate,
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
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildGoalIcon(fund.templateKey),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fund.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        'Cần: ${AppHelperFunction.formatAmount(fund.target ?? 0, 'VND')}',
                        style: const TextStyle(fontSize: 12, color: AppColors.text3),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.primary),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onUpdate();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                    const PopupMenuItem(value: 'delete', child: Text('Xóa', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SavingGoalProgressBar(
              currentValue: fund.savedAmount,
              targetValue: fund.target ?? 0,
              showPercentage: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalIcon(String? key) {
    String emoji = '🎯';

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}
