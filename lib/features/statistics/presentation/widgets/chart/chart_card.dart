import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.amount,
    required this.limit,
  });

  final String title;
  final int amount;
  final double limit;

  @override
  Widget build(BuildContext context) {
    final double limitValue = limit;
    final double spentValue = amount.toDouble();
    final double percentValue =
        (limitValue > 0) ? (spentValue / limitValue).clamp(0.0, 1.0) : 0.0;
    final int percentDisplay = (percentValue * 100).round();
    final bool isOverLimit = spentValue > limitValue;

    return Container(
      constraints: const BoxConstraints(
        minWidth: 200,
        maxWidth: 240,
        minHeight: 120,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 28.0,
                  lineWidth: 6.0,
                  percent: percentValue,
                  center: Text(
                    "$percentDisplay%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  progressColor:
                      isOverLimit ? AppColors.error : AppColors.primary,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeSm,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  AppHelperFunction.formatAmount(amount.toDouble(), 'VND'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeLg,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hạn mức ${AppHelperFunction.formatAmount(limit.toDouble(), 'VND')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
