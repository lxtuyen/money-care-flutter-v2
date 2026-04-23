import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class SavingGoalProgressBar extends StatelessWidget {
  final double currentValue;
  final double targetValue;
  final bool showPercentage;

  const SavingGoalProgressBar({
    super.key,
    required this.currentValue,
    required this.targetValue,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = targetValue > 0
        ? (currentValue / targetValue).clamp(0.0, 1.0)
        : 0.0;
    final int displayPercentage = (percentage * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tiến độ',
                  style: TextStyle(fontSize: 12, color: AppColors.text4),
                ),
                Text(
                  '$displayPercentage%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        Stack(
          children: [
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
