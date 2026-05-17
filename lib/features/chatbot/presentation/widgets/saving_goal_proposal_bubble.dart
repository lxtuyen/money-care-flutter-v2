import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_stat_chip.dart';

class SavingGoalProposalBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const SavingGoalProposalBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final chatController = Get.find<ChatController>();
    final appController = Get.find<AppController>();

    final proposal = SavingGoalProposal.fromMap(metadata);
    final userId = appController.userId.value ?? 0;
    final themeColor = proposal.isImpossible
        ? AppColors.error
        : proposal.isWarning
        ? AppColors.warning
        : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colors.borderSecondary, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proposal.isImpossible
                    ? "Mục tiêu không khả thi"
                    : proposal.isWarning
                    ? "CẢNH BÁO KẾ HOẠCH"
                    : "ĐỀ XUẤT KẾ HOẠCH TÍCH LŨY",
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: themeColor,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                proposal.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // AI message
          if (proposal.aiMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: proposal.isImpossible
                    ? AppColors.error.withOpacity(0.06)
                    : proposal.isWarning
                    ? AppColors.warning.withOpacity(0.06)
                    : proposal.isFinalized
                    ? AppColors.income.withOpacity(0.06)
                    : AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: proposal.isImpossible
                      ? AppColors.error.withOpacity(0.2)
                      : proposal.isWarning
                      ? AppColors.warning.withOpacity(0.2)
                      : proposal.isFinalized
                      ? AppColors.income.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                proposal.aiMessage,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textPrimary,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 14),

          // Stats grid
          Row(
            children: [
              SavingGoalStatChip(
                label: AppHelperFunction.formatAmount(proposal.target),
                subtitle: "Mục tiêu",
                colors: colors,
              ),
              const SizedBox(width: 8),
              SavingGoalStatChip(
                label: "${proposal.months} tháng",
                subtitle: "Thời gian",
                colors: colors,
              ),
              if (proposal.hasPlan && proposal.capacity > 0) ...[
                const SizedBox(width: 8),
                SavingGoalStatChip(
                  label: AppHelperFunction.formatAmount(proposal.suggestedMonthlySaving),
                  subtitle: "Đề xuất/tháng",
                  colors: colors,
                ),
              ],
            ],
          ),

          if (proposal.endDate != null && !proposal.isImpossible) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    size: 15,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Dự kiến hoàn thành: ${DateFormat('MM/yyyy').format(proposal.endDate!)}",
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (proposal.durationOptions.isNotEmpty && !proposal.isImpossible && !proposal.isWarning) ...[
            const SizedBox(height: 14),
            _DurationOptions(
              options: proposal.durationOptions,
              selectedMonths: proposal.months,
              name: proposal.name,
              target: proposal.target,
              userId: userId,
              controller: chatController,
              colors: colors,
              maxMonthlySaving: proposal.capacity,
              isDisabled: proposal.isFinalized,
            ),
          ],

          const SizedBox(height: 16),

          if (proposal.isFinalized) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.income.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.income.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 17,
                    color: AppColors.income,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      proposal.finalizedLabel,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.income,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (proposal.isWarning) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: proposal.isImpossible
                    ? null
                    : () {
                        chatController.sendCustomMessage(
                          "Tôi đồng ý với đề xuất trên",
                          '/confirm_saving_goal {"name": "${proposal.name}", "target": ${proposal.target}, "months": ${proposal.months}}',
                          userId,
                        );
                      },
                icon: const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  "Đồng ý tạo",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: proposal.isImpossible
                      ? Colors.grey
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DurationOptions extends StatelessWidget {
  final List<SavingGoalDurationOption> options;
  final int selectedMonths;
  final String name;
  final double target;
  final int userId;
  final ChatController controller;
  final AppThemeColors colors;
  final double maxMonthlySaving;
  final bool isDisabled;

  const _DurationOptions({
    required this.options,
    required this.selectedMonths,
    required this.name,
    required this.target,
    required this.userId,
    required this.controller,
    required this.colors,
    required this.maxMonthlySaving,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final months = option.months;
        final monthlySaving = option.monthlySaving;
        final label = option.label;
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
                    if (needsWarning) {
                      controller.sendCustomMessage(
                        "Tôi muốn hoàn thành trong $months tháng",
                        '/change_saving_goal_duration {"name": "$name", "target": $target, "months": $months}',
                        userId,
                      );
                      return;
                    }

                    controller.sendCustomMessage(
                      "Tôi đồng ý tạo mục tiêu trong $months tháng",
                      '/confirm_saving_goal {"name": "$name", "target": $target, "months": $months}',
                      userId,
                    );
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isRecommended
                    ? AppColors.primary.withOpacity(0.08)
                    : needsWarning
                    ? AppColors.warning.withOpacity(0.08)
                    : colors.surfaceBackground.withOpacity(0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isRecommended
                      ? AppColors.primary.withOpacity(0.35)
                      : needsWarning
                      ? AppColors.warning.withOpacity(0.35)
                      : colors.borderSecondary.withOpacity(0.7),
                ),
              ),
              child: Text(
                "$label: $months tháng - cần ${AppHelperFunction.formatAmount(monthlySaving)}/tháng",
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
      }).toList(),
    );
  }
}

class SavingGoalProposal {
  final String name;
  final double target;
  final int months;
  final double capacity;
  final double suggestedMonthlySaving;
  final List<SavingGoalDurationOption> durationOptions;
  final String aiMessage;
  final DateTime? endDate;
  final bool hasPlan;
  final bool isImpossible;
  final bool isWarning;
  final bool isFinalized;
  final String finalizedLabel;

  SavingGoalProposal({
    required this.name,
    required this.target,
    required this.months,
    required this.capacity,
    required this.suggestedMonthlySaving,
    required this.durationOptions,
    required this.aiMessage,
    this.endDate,
    required this.hasPlan,
    required this.isImpossible,
    required this.isWarning,
    required this.isFinalized,
    required this.finalizedLabel,
  });

  factory SavingGoalProposal.fromMap(Map<String, dynamic> map) {
    final months = (map['monthsEstimate'] as num?)?.toInt() ?? 0;
    final target = (map['target'] as num?)?.toDouble() ?? 0;
    final endDateStr = map['endDate'];
    final rawOptions = map['durationOptions'];

    List<SavingGoalDurationOption> parsedOptions = [];
    if (rawOptions is List && rawOptions.isNotEmpty) {
      parsedOptions = rawOptions
          .whereType<Map>()
          .map((option) => SavingGoalDurationOption.fromMap(
                Map<String, dynamic>.from(option),
                target,
                months,
              ))
          .toList();
    } else if (target > 0 && months > 0) {
      final optionMonths = <int>{
        if (months > 1) months - 1,
        months,
        months + 1,
      }.toList();

      parsedOptions = optionMonths.map((m) {
        final type = m < months
            ? 'faster'
            : m == months
            ? 'recommended'
            : 'relaxed';

        return SavingGoalDurationOption(
          type: type,
          label: type == 'faster'
              ? 'Gấp'
              : type == 'recommended'
              ? 'Khuyến nghị'
              : 'Thoải mái',
          months: m,
          monthlySaving: (target / m).ceilToDouble(),
          isRecommended: type == 'recommended',
        );
      }).toList();
    }

    return SavingGoalProposal(
      name: map['name'] ?? 'Mục tiêu',
      target: target,
      months: months,
      capacity: (map['monthlySavingCapacity'] as num?)?.toDouble() ?? 0,
      suggestedMonthlySaving:
          (map['suggestedMonthlySaving'] as num?)?.toDouble() ??
              (months > 0 ? target / months : 0),
      durationOptions: parsedOptions,
      aiMessage: map['aiMessage'] ?? '',
      endDate: endDateStr != null ? DateTime.tryParse(endDateStr) : null,
      hasPlan: map['hasPlan'] ?? false,
      isImpossible: map['isImpossible'] ?? false,
      isWarning: map['isWarning'] == true,
      isFinalized: map['isFinalized'] == true,
      finalizedLabel: map['finalizedLabel']?.toString() ??
          'Mục tiêu này đã được tạo',
    );
  }
}

class SavingGoalDurationOption {
  final String type;
  final String label;
  final int months;
  final double monthlySaving;
  final bool isRecommended;

  SavingGoalDurationOption({
    required this.type,
    required this.label,
    required this.months,
    required this.monthlySaving,
    required this.isRecommended,
  });

  factory SavingGoalDurationOption.fromMap(
    Map<String, dynamic> map,
    double fallbackTarget,
    int fallbackMonths,
  ) {
    final m = (map['months'] as num?)?.toInt() ?? fallbackMonths;
    return SavingGoalDurationOption(
      type: map['type']?.toString() ?? 'recommended',
      label: map['label']?.toString() ?? 'Khuyến nghị',
      months: m,
      monthlySaving: (map['monthlySaving'] as num?)?.toDouble() ??
          (m > 0 ? fallbackTarget / m : 0),
      isRecommended: map['isRecommended'] == true ||
          map['type'] == 'recommended' ||
          m == fallbackMonths,
    );
  }
}
