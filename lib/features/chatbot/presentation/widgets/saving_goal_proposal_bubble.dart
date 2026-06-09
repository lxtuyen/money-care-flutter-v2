import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_stat_chip.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/features/chatbot/presentation/models/saving_goal_proposal_model.dart';
import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_duration_options.dart';
import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_budget_preview.dart';

class SavingGoalProposalBubble extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const SavingGoalProposalBubble({super.key, required this.metadata});

  @override
  State<SavingGoalProposalBubble> createState() =>
      _SavingGoalProposalBubbleState();
}

class _SavingGoalProposalBubbleState extends State<SavingGoalProposalBubble> {
  late List<SavingGoalBudgetItem> budgetItems;

  @override
  void initState() {
    super.initState();
    budgetItems = SavingGoalProposal.fromMap(widget.metadata).budgetItems;
  }

  @override
  void didUpdateWidget(covariant SavingGoalProposalBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.metadata, widget.metadata)) {
      budgetItems = SavingGoalProposal.fromMap(widget.metadata).budgetItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final chatController = Get.find<ChatController>();
    final appController = Get.find<AppController>();

    final proposal = SavingGoalProposal.fromMap(widget.metadata);
    final userId = appController.userId.value ?? 0;
    final budgetTotal = _budgetTotal;
    final confirmTotalAmount = proposal.totalAmount > 0
        ? proposal.totalAmount
        : budgetTotal + proposal.suggestedMonthlySaving;
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



          if (proposal.aiMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: proposal.isImpossible
                    ? AppColors.error.withValues(alpha: 0.06)
                    : proposal.isWarning
                    ? AppColors.warning.withValues(alpha: 0.06)
                    : AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: proposal.isImpossible
                      ? AppColors.error.withValues(alpha: 0.2)
                      : proposal.isWarning
                      ? AppColors.warning.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.2),
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
                label: proposal.initFund > 0
                    ? "${AppHelperFunction.formatShortAmount(proposal.initFund)}/${AppHelperFunction.formatShortAmount(proposal.target)}"
                    : AppHelperFunction.formatAmount(proposal.target),
                subtitle: "Mục tiêu",
                colors: colors,
              ),
              const SizedBox(width: 8),
              SavingGoalStatChip(
                label: proposal.durationLabel,
                subtitle: "Dự kiến",
                colors: colors,
              ),
              if (proposal.hasPlan && proposal.capacity > 0) ...[
                const SizedBox(width: 8),
                SavingGoalStatChip(
                  label: AppHelperFunction.formatAmount(
                    proposal.suggestedDailySpending,
                  ),
                  subtitle: "Chi/ngày",
                  colors: colors,
                ),
              ],
            ],
          ),

          if (proposal.endDate != null && !proposal.isImpossible) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
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
                        "Dự kiến hoàn thành: ${DateFormat('dd/MM/yyyy').format(proposal.endDate!)}",
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
            ),
          ],

          if (!proposal.isImpossible &&
              ((proposal.durationOptions.isNotEmpty &&
                      !proposal.isWarning &&
                      !proposal.isRequestedDuration) ||
                  proposal.isRequestedDuration)) ...[
            const SizedBox(height: 14),
            SavingGoalDurationOptions(
              options: proposal.durationOptions,
              selectedDays: proposal.daysEstimate,
              name: proposal.name,
              target: proposal.target,
              userId: userId,
              controller: chatController,
              colors: colors,
              maxMonthlySaving: proposal.capacity,
              isDisabled: proposal.isFinalized,
              initFund: proposal.initFund,
              sourceWalletId: proposal.sourceWalletId,
              totalAmount: proposal.totalAmount,
              showPresetOptions: !proposal.isRequestedDuration,
            ),
          ],

          if (budgetItems.isNotEmpty && !proposal.preserveCurrentBudget) ...[
            const SizedBox(height: 14),
            SavingGoalBudgetPreview(
              items: budgetItems,
              colors: colors,
              savingAmount: proposal.suggestedMonthlySaving,
              budgetTotal: budgetTotal,
              totalAmount: confirmTotalAmount,
              onEdit: _updateBudgetItem,
              onDelete: _deleteBudgetItem,
            ),
          ],

          const SizedBox(height: 16),

          if (proposal.isFinalized) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      proposal.finalizedLabel,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            PrimaryButton(
              label: "Đồng ý tạo",
              onPressed: proposal.isImpossible
                  ? null
                  : () {
                      final payload = proposal.toConfirmPayload(
                        budgetItems: budgetItems,
                        totalAmount: confirmTotalAmount,
                      );
                      chatController.sendCustomMessage(
                        "Tôi đồng ý với đề xuất trên",
                        '/confirm_saving_goal ${jsonEncode(payload)}',
                        userId,
                      );
                    },
              icon: const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: Colors.white,
              ),
              backgroundColor: proposal.isImpossible
                  ? Colors.grey
                  : AppColors.primary,
              height: 48,
              fontSize: 13,
              borderRadius: 14,
              elevation: 0,
            ),
          ],
        ],
      ),
    );
  }

  double get _budgetTotal {
    return budgetItems.fold(0, (sum, item) => sum + item.monthlyLimit);
  }

  void _updateBudgetItem(int index, SavingGoalBudgetItem item) {
    setState(() {
      budgetItems[index] = item;
    });
  }

  void _deleteBudgetItem(int index) {
    setState(() {
      budgetItems.removeAt(index);
    });
  }

}
