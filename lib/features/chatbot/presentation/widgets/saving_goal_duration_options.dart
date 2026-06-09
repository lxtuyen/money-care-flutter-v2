import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/chatbot/presentation/models/saving_goal_proposal_model.dart';

class SavingGoalDurationOptions extends StatelessWidget {
  final List<SavingGoalDurationOption> options;
  final int selectedDays;
  final String name;
  final double target;
  final int userId;
  final ChatController controller;
  final AppThemeColors colors;
  final double maxMonthlySaving;
  final bool isDisabled;
  final double initFund;
  final int sourceWalletId;
  final double totalAmount;
  final bool showPresetOptions;

  const SavingGoalDurationOptions({
    super.key,
    required this.options,
    required this.selectedDays,
    required this.name,
    required this.target,
    required this.userId,
    required this.controller,
    required this.colors,
    required this.maxMonthlySaving,
    required this.isDisabled,
    required this.initFund,
    required this.sourceWalletId,
    required this.totalAmount,
    this.showPresetOptions = true,
  });

  @override
  Widget build(BuildContext context) {
    final widgets =
        (showPresetOptions ? options.take(2) : const <SavingGoalDurationOption>[]).map((
          option,
        ) {
          final days = option.days;
          final monthlySaving = option.monthlySaving;
          final dailySpending = _dailySpendingLimit(monthlySaving);
          final label = option.label;
          final durationText = option.durationText;
          final isRecommended = option.isRecommended;
          final needsWarning =
              maxMonthlySaving > 0 && monthlySaving > maxMonthlySaving;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isDisabled
                  ? null
                  : () {
                      controller.sendCustomMessage(
                        "Tôi muốn hoàn thành trong $durationText",
                        '/confirm_saving_goal ${jsonEncode({"name": name, "target": target, "months": option.months, "days": days, "initFund": initFund, "sourceWalletId": sourceWalletId, "budgetItems": [], "preserveCurrentBudget": option.preserveCurrentBudget})}',
                        userId,
                      );
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isRecommended
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : needsWarning
                      ? AppColors.warning.withValues(alpha: 0.08)
                      : colors.surfaceBackground.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isRecommended
                        ? AppColors.primary.withValues(alpha: 0.35)
                        : needsWarning
                        ? AppColors.warning.withValues(alpha: 0.35)
                        : colors.borderSecondary.withValues(alpha: 0.7),
                  ),
                ),
                child: Text(
                  (label.toLowerCase().contains('giữ ngân sách') ||
                          label.toLowerCase().contains('giu ngan sach'))
                      ? "$durationText - chi TB ${AppHelperFunction.formatAmount(dailySpending)}/ngày"
                      : "$label: $durationText - chi TB ${AppHelperFunction.formatAmount(dailySpending)}/ngày",
                  style: TextStyle(
                    fontSize: 12.2,
                    fontWeight: isRecommended
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: isRecommended
                        ? AppColors.primary
                        : colors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList();

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isDisabled
              ? null
              : () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(
                      Duration(days: selectedDays <= 0 ? 30 : selectedDays),
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365 * 10),
                    ),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            onSurface: colors.textPrimary,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final targetDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                    );
                    int days = targetDate.difference(today).inDays;
                    if (days <= 0) days = 1;

                    final formattedDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(pickedDate);
                    controller.sendCustomMessage(
                      "Tôi muốn hoàn thành vào ngày $formattedDate",
                      '/change_saving_goal_duration ${jsonEncode({"name": name, "target": target, "days": days, "initFund": initFund, "sourceWalletId": sourceWalletId})}',
                      userId,
                    );
                  }
                },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surfaceBackground.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.borderSecondary.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tự chọn ngày kết thúc",
                  style: TextStyle(
                    fontSize: 12.2,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(children: widgets);
  }

  double _dailySpendingLimit(double monthlySaving) {
    if (totalAmount <= 0) return 0;
    return AppHelperFunction.roundVndUp(
      (totalAmount - monthlySaving).clamp(0, double.infinity) / 30,
    );
  }
}
