import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:money_care/core/constants/colors.dart';

class BudgetDetailDialog extends StatelessWidget {
  final String title;
  final String limit;
  final String spent;
  final bool isOverLimit;

  final bool isIncome;

  const BudgetDetailDialog({
    super.key,
    required this.title,
    required this.limit,
    required this.spent,
    required this.isOverLimit,
    this.isIncome = false,
  });

  double _parseNumber(String s) =>
      double.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final double limitValue = _parseNumber(limit);
    final double spentValue = _parseNumber(spent);
    final double percent = (limitValue > 0)
        ? (spentValue / limitValue).clamp(0.0, 1.0)
        : 0.0;
    final int percentInt = (percent * 100).round();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isIncome ? 'Tổng quan thu nhập' : 'Hạn mức chi tiêu',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: AppColors.text1),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              'Phân loại: $title',
              style: const TextStyle(color: AppColors.text1, fontSize: 14),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 46.0,
                  lineWidth: 8.0,
                  percent: percent,
                  center: Text(
                    "$percentInt%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  progressColor: isIncome
                      ? AppColors.success
                      : (isOverLimit ? AppColors.error : AppColors.error),
                  backgroundColor:
                      (isIncome ? AppColors.success : AppColors.error)
                          .withOpacity(0.15),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isIncome ? "Mục tiêu: " : "Hạn mức: ",
                          style: const TextStyle(color: AppColors.text1),
                        ),
                        Text(
                          limitValue > 0 ? limit : "Chưa thiết lập",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: limitValue > 0
                                ? AppColors.text1
                                : AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          isIncome ? "Đã nhận: " : "Đã tiêu: ",
                          style: const TextStyle(color: AppColors.text1),
                        ),
                        Text(
                          spent,
                          style: TextStyle(
                            color: isIncome
                                ? AppColors.success
                                : (isOverLimit
                                      ? AppColors.error
                                      : AppColors.success),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
