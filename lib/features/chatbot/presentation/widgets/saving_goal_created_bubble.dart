import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_stat_chip.dart';

class SavingGoalCreatedBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const SavingGoalCreatedBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final model = SavingGoalCreatedModel.fromMap(metadata);
    final themeColor = AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colors.borderSecondary, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MỤC TIÊU ĐÃ ĐƯỢC TẠO!",
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: themeColor,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                model.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (model.aiMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                model.aiMessage,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textPrimary,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 14),

          Row(
            children: [
              SavingGoalStatChip(
                label: AppHelperFunction.formatAmount(model.target),
                subtitle: "Mục tiêu",
                colors: colors,
              ),
              const SizedBox(width: 8),
              SavingGoalStatChip(
                label: "${model.months} tháng",
                subtitle: "Thời gian",
                colors: colors,
              ),
              if (model.hasPlan && model.capacity > 0) ...[
                const SizedBox(width: 8),
                SavingGoalStatChip(
                  label: AppHelperFunction.formatAmount(
                    model.suggestedMonthlySaving,
                  ),
                  subtitle: "Đề xuất/tháng",
                  colors: colors,
                ),
              ],
            ],
          ),

          if (model.endDate != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 15,
                    color: themeColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Dự kiến hoàn thành: ${DateFormat('MM/yyyy').format(model.endDate!)}",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SavingGoalCreatedModel {
  final String name;
  final double target;
  final int months;
  final double capacity;
  final double suggestedMonthlySaving;
  final String aiMessage;
  final DateTime? endDate;
  final bool hasPlan;

  SavingGoalCreatedModel({
    required this.name,
    required this.target,
    required this.months,
    required this.capacity,
    required this.suggestedMonthlySaving,
    required this.aiMessage,
    this.endDate,
    required this.hasPlan,
  });

  factory SavingGoalCreatedModel.fromMap(Map<String, dynamic> map) {
    final months = (map['monthsEstimate'] as num?)?.toInt() ?? 0;
    final target = (map['target'] as num?)?.toDouble() ?? 0;
    final endDateStr = map['endDate'];

    return SavingGoalCreatedModel(
      name: map['name'] ?? 'Mục tiêu',
      target: target,
      months: months,
      capacity: (map['monthlySavingCapacity'] as num?)?.toDouble() ?? 0,
      suggestedMonthlySaving:
          (map['suggestedMonthlySaving'] as num?)?.toDouble() ??
          (months > 0 ? target / months : 0),
      aiMessage: map['aiMessage'] ?? '',
      endDate: endDateStr != null ? DateTime.tryParse(endDateStr) : null,
      hasPlan: map['hasPlan'] ?? false,
    );
  }
}
