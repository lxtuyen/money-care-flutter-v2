import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';

class ExpiredGoalPopup extends StatelessWidget {
  final ExpiredGoalInfoModel goal;

  const ExpiredGoalPopup({super.key, required this.goal});

  static void show(ExpiredGoalInfoModel goal) {
    Get.dialog(
      ExpiredGoalPopup(goal: goal),
      barrierDismissible: false,
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SavingGoalController>();
    final isSuccess = goal.completionPercentage >= 100;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isSuccess ? '🏆' : '💪', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              isSuccess ? 'Chúc mừng bạn!' : 'Cố gắng lên!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isSuccess 
                ? 'Bạn đã hoàn thành xuất sắc mục tiêu "${goal.name}"!'
                : 'Mục tiêu "${goal.name}" đã kết thúc. Hãy tiếp tục nỗ lực nhé!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.text3),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _StatRow(
                    icon: Icons.flag_rounded,
                    label: 'Tiến độ đạt được',
                    value: '${goal.completionPercentage.toStringAsFixed(1)}%',
                    valueColor: isSuccess ? AppColors.success : AppColors.primary,
                  ),
                  const Divider(height: 16),
                  _StatRow(
                    icon: Icons.savings_rounded,
                    label: 'Tổng mục tiêu',
                    value: _formatCurrency(goal.target),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Main Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   Get.back();
                   Get.toNamed(RoutePath.createSavingGoal);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Tạo mục tiêu mới',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            if (!isSuccess) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final baseDate = goal.endDate ?? DateTime.now();
                    final newDate = await showStyledDatePicker(
                      context: context,
                      initialDate: baseDate.add(const Duration(days: 30)),
                      firstDate: baseDate.add(const Duration(days: 1)),
                    );
                    if (newDate != null) {
                      final success = await controller.extendGoal(goal.id, newDate);
                      if (success) {
                        Get.back();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Gia hạn mục tiêu',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      controller.deselectGoal();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderPrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Chế độ bình thường',
                      style: TextStyle(color: AppColors.text2, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.text1,
          ),
        ),
      ],
    );
  }
}
