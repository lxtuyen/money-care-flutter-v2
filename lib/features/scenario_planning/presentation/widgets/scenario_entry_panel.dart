import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';

class ScenarioEntryPanel extends StatelessWidget {
  final int? goalId;

  const ScenarioEntryPanel({super.key, this.goalId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RoutePath.scenarioPlanning,
        arguments: goalId == null ? null : {'goalId': goalId},
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4FAFD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD6EAF8)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_graph_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thử kịch bản tài chính',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.text1,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Mô phỏng thu nhập, chi tiêu và tác động tới mục tiêu.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.text3,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
          ],
        ),
      ),
    );
  }
}
