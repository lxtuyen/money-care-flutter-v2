import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';

class GoalCompletionDialog extends StatelessWidget {
  final SavingGoalReportModel report;

  const GoalCompletionDialog({super.key, required this.report});

  static void show(SavingGoalReportModel report) {
    Get.dialog(GoalCompletionDialog(report: report), barrierDismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tuyệt vời!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bạn đã đạt mục tiêu "${report.name}" với số dư hiện tại là ${AppHelperFunction.formatAmount(report.currentBalance, currency: 'VND')}.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Tuyệt vời!',
              onPressed: () {
                final controller = Get.find<SavingGoalController>();
                controller.markAsNotified(report.id);
                controller.deselectGoal();
                Get.back();
              },
              backgroundColor: AppColors.success,
              height: 48,
              borderRadius: 12,
              fontSize: 14,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }
}
