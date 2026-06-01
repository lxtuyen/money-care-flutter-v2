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

double _roundVndUp(num amount, {int unit = 1000}) {
  if (amount <= 0) return 0;
  return (amount / unit).ceilToDouble() * unit;
}

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

  String _formatShortAmount(double amount) {
    if (amount >= 1000000) {
      double value = amount / 1000000;
      if (value == value.toInt()) {
        return "${value.toInt()}M";
      }
      return "${value.toStringAsFixed(1)}M";
    } else if (amount >= 1000) {
      double value = amount / 1000;
      if (value == value.toInt()) {
        return "${value.toInt()}k";
      }
      return "${value.toStringAsFixed(1)}k";
    }
    return amount.toInt().toString();
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

          // AI message
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
                    ? "${_formatShortAmount(proposal.initFund)}/${_formatShortAmount(proposal.target)}"
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
            _DurationOptions(
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
            _BudgetItemsPreview(
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
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

class _DurationOptions extends StatelessWidget {
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

  const _DurationOptions({
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
                        '/confirm_saving_goal ${jsonEncode({'name': name, 'target': target, 'months': option.months, 'days': days, 'initFund': initFund, 'sourceWalletId': sourceWalletId, 'budgetItems': [], 'preserveCurrentBudget': option.preserveCurrentBudget})}',
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
                  "$label: $durationText - chi TB ${AppHelperFunction.formatAmount(dailySpending)}/ngày",
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
                      '/change_saving_goal_duration ${jsonEncode({'name': name, 'target': target, 'days': days, 'initFund': initFund, 'sourceWalletId': sourceWalletId})}',
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
    return _roundVndUp(
      (totalAmount - monthlySaving).clamp(0, double.infinity) / 30,
    );
  }
}

class _BudgetItemsPreview extends StatelessWidget {
  final List<SavingGoalBudgetItem> items;
  final AppThemeColors colors;
  final double savingAmount;
  final double budgetTotal;
  final double totalAmount;
  final void Function(int, SavingGoalBudgetItem) onEdit;
  final void Function(int) onDelete;

  const _BudgetItemsPreview({
    required this.items,
    required this.colors,
    required this.savingAmount,
    required this.budgetTotal,
    required this.totalAmount,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceBackground.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.borderSecondary.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Ngân sách đề xuất',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _BudgetSummaryRow(
            label: 'T\u1ed5ng ti\u1ec1n k\u1ebf ho\u1ea1ch',
            amount: totalAmount,
            colors: colors,
            isStrong: true,
          ),
          const SizedBox(height: 6),
          _BudgetSummaryRow(
            label: 'Chi ph\u00ed \u0111\u1ec1 xu\u1ea5t',
            amount: budgetTotal,
            colors: colors,
          ),
          const SizedBox(height: 6),
          _BudgetSummaryRow(
            label: 'T\u00edch l\u0169y m\u1ee5c ti\u00eau',
            amount: savingAmount,
            colors: colors,
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.borderSecondary.withValues(alpha: 0.65),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.categoryName,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppHelperFunction.formatAmount(item.monthlyLimit),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Ch\u1ec9nh s\u1eeda',
                    onPressed: () => _showEditDialog(context, index, item),
                    icon: Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'X\u00f3a',
                    onPressed: () => onDelete(index),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 19,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    int index,
    SavingGoalBudgetItem item,
  ) {
    final controller = TextEditingController(
      text: item.monthlyLimit.toInt().toString(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            item.categoryName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Ng\u00e2n s\u00e1ch/th\u00e1ng',
              suffixText: '\u0111',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('H\u1ee7y'),
            ),
            ElevatedButton(
              onPressed: () {
                final rawAmount = controller.text.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                final amount = double.tryParse(rawAmount) ?? 0;

                onEdit(
                  index,
                  item.copyWith(amount: amount, monthlyLimit: amount),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('L\u01b0u'),
            ),
          ],
        );
      },
    );
  }
}

class _BudgetSummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final AppThemeColors colors;
  final bool isStrong;

  const _BudgetSummaryRow({
    required this.label,
    required this.amount,
    required this.colors,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isStrong
            ? AppColors.primary.withValues(alpha: 0.08)
            : colors.surfaceBackground.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isStrong ? FontWeight.w800 : FontWeight.w600,
                color: isStrong ? AppColors.primary : colors.textSecondary,
              ),
            ),
          ),
          Text(
            AppHelperFunction.formatAmount(amount),
            style: TextStyle(
              fontSize: 12.2,
              fontWeight: FontWeight.w800,
              color: isStrong ? AppColors.primary : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class SavingGoalProposal {
  final String name;
  final double target;
  final int months;
  final int daysEstimate;
  final double capacity;
  final double suggestedMonthlySaving;
  final double suggestedDailySaving;
  final double suggestedDailySpending;
  final List<SavingGoalDurationOption> durationOptions;
  final String aiMessage;
  final DateTime? endDate;
  final bool hasPlan;
  final bool isImpossible;
  final bool isWarning;
  final bool isFinalized;
  final String finalizedLabel;
  final double initFund;
  final int sourceWalletId;
  final double remainingTarget;
  final double totalAmount;
  final List<SavingGoalBudgetItem> budgetItems;
  final bool preserveCurrentBudget;
  final bool isRequestedDuration;

  SavingGoalProposal({
    required this.name,
    required this.target,
    required this.months,
    required this.daysEstimate,
    required this.capacity,
    required this.suggestedMonthlySaving,
    required this.suggestedDailySaving,
    required this.suggestedDailySpending,
    required this.durationOptions,
    required this.aiMessage,
    this.endDate,
    required this.hasPlan,
    required this.isImpossible,
    required this.isWarning,
    required this.isFinalized,
    required this.finalizedLabel,
    required this.initFund,
    required this.sourceWalletId,
    required this.remainingTarget,
    required this.totalAmount,
    required this.budgetItems,
    required this.preserveCurrentBudget,
    required this.isRequestedDuration,
  });

  factory SavingGoalProposal.fromMap(Map<String, dynamic> map) {
    final months = (map['monthsEstimate'] as num?)?.toInt() ?? 0;
    final daysEstimate =
        (map['daysEstimate'] as num?)?.toInt() ??
        (months > 0 ? months * 30 : 0);
    final target = (map['target'] as num?)?.toDouble() ?? 0;
    final endDateStr = map['endDate'];
    final rawOptions = map['durationOptions'];
    final initFund = (map['initFund'] as num?)?.toDouble() ?? 0;
    final sourceWalletId = (map['sourceWalletId'] as num?)?.toInt() ?? 0;
    final remainingTarget =
        (map['remainingTarget'] as num?)?.toDouble() ?? target;
    final rawBudgetItems = map['budgetItems'];
    final isRequestedDuration = map['isRequestedDuration'] == true;

    List<SavingGoalDurationOption> parsedOptions = [];
    if (rawOptions is List && rawOptions.isNotEmpty) {
      parsedOptions = rawOptions
          .whereType<Map>()
          .map(
            (option) => SavingGoalDurationOption.fromMap(
              Map<String, dynamic>.from(option),
              remainingTarget,
              months,
              daysEstimate,
            ),
          )
          .toList();
    } else if (!isRequestedDuration && remainingTarget > 0 && months > 0) {
      final optionDays = <int>{
        if (daysEstimate > 1) daysEstimate - 1,
        daysEstimate,
        daysEstimate + 7,
      }.toList();

      parsedOptions = optionDays.map((days) {
        final type = days < daysEstimate
            ? 'faster'
            : days == daysEstimate
            ? 'recommended'
            : 'relaxed';
        final dailySaving = _roundVndUp(remainingTarget / days);
        final optionMonths = (days / 30).ceil();
        final monthlySaving = _roundVndUp(remainingTarget / (days / 30));

        return SavingGoalDurationOption(
          type: type,
          label: type == 'faster'
              ? 'Gấp'
              : type == 'recommended'
              ? 'Khuyến nghị'
              : 'Thoải mái',
          months: optionMonths,
          days: days,
          durationText: _formatDuration(days),
          monthlySaving: monthlySaving,
          dailySaving: dailySaving,
          isRecommended: type == 'recommended',
          preserveCurrentBudget: false,
        );
      }).toList();
    }

    final totalAmount = (map['totalAmount'] as num?)?.toDouble() ?? 0;
    final suggestedMonthlySaving = _roundVndUp(
      (map['suggestedMonthlySaving'] as num?)?.toDouble() ??
          (months > 0 ? remainingTarget / months : 0),
    );
    final suggestedDailySaving = _roundVndUp(
      (map['suggestedDailySaving'] as num?)?.toDouble() ??
          (daysEstimate > 0 ? remainingTarget / daysEstimate : 0),
    );
    final suggestedDailySpending = _roundVndUp(
      (map['suggestedDailySpending'] as num?)?.toDouble() ??
          (totalAmount > 0
              ? (totalAmount - suggestedMonthlySaving).clamp(
                      0,
                      double.infinity,
                    ) /
                    30
              : suggestedDailySaving),
    );

    return SavingGoalProposal(
      name: map['name'] ?? 'Mục tiêu',
      target: target,
      months: months,
      daysEstimate: daysEstimate,
      capacity: (map['monthlySavingCapacity'] as num?)?.toDouble() ?? 0,
      suggestedMonthlySaving: suggestedMonthlySaving,
      suggestedDailySaving: suggestedDailySaving,
      suggestedDailySpending: suggestedDailySpending,
      durationOptions: parsedOptions,
      aiMessage: map['aiMessage'] ?? '',
      endDate: endDateStr != null ? DateTime.tryParse(endDateStr) : null,
      hasPlan: map['hasPlan'] ?? false,
      isImpossible: map['isImpossible'] ?? false,
      isWarning: map['isWarning'] == true,
      isFinalized: map['isFinalized'] == true,
      finalizedLabel:
          map['finalizedLabel']?.toString() ?? 'Mục tiêu này đã được tạo',
      initFund: initFund,
      sourceWalletId: sourceWalletId,
      remainingTarget: remainingTarget,
      totalAmount: totalAmount,
      budgetItems: rawBudgetItems is List
          ? rawBudgetItems
                .whereType<Map>()
                .map(
                  (item) => SavingGoalBudgetItem.fromMap(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      preserveCurrentBudget: map['preserveCurrentBudget'] == true,
      isRequestedDuration: isRequestedDuration,
    );
  }

  Map<String, dynamic> toConfirmPayload({
    List<SavingGoalBudgetItem>? budgetItems,
    double? totalAmount,
  }) {
    final selectedBudgetItems = budgetItems ?? this.budgetItems;

    return {
      'name': name,
      'target': target,
      'months': months,
      'days': daysEstimate,
      'initFund': initFund,
      'sourceWalletId': sourceWalletId,
      'totalAmount': totalAmount ?? this.totalAmount,
      'budgetItems': selectedBudgetItems.map((item) => item.toJson()).toList(),
      'preserveCurrentBudget': preserveCurrentBudget,
    };
  }

  String get durationLabel => _formatDuration(daysEstimate);

  static String _formatDuration(int daysValue) {
    final days = daysValue <= 0 ? 0 : daysValue;
    if (days <= 0) return '0 ngày';
    if (days < 30) return '$days ngày';

    final months = days ~/ 30;
    final remainingDays = days % 30;
    if (remainingDays == 0) return '$months tháng';
    return '$months tháng $remainingDays ngày';
  }
}

class SavingGoalBudgetItem {
  final int? categoryId;
  final String categoryName;
  final double amount;
  final double monthlyLimit;
  final String frequencyType;
  final int frequencyValue;

  const SavingGoalBudgetItem({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.monthlyLimit,
    required this.frequencyType,
    required this.frequencyValue,
  });

  factory SavingGoalBudgetItem.fromMap(Map<String, dynamic> map) {
    return SavingGoalBudgetItem(
      categoryId: (map['categoryId'] as num?)?.toInt(),
      categoryName: map['categoryName']?.toString() ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      monthlyLimit:
          (map['monthlyLimit'] as num?)?.toDouble() ??
          (map['amount'] as num?)?.toDouble() ??
          0,
      frequencyType: map['frequencyType']?.toString() ?? 'monthly',
      frequencyValue: (map['frequencyValue'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) 'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'monthlyLimit': monthlyLimit,
      'frequencyType': frequencyType,
      'frequencyValue': frequencyValue,
    };
  }

  SavingGoalBudgetItem copyWith({
    int? categoryId,
    String? categoryName,
    double? amount,
    double? monthlyLimit,
    String? frequencyType,
    int? frequencyValue,
  }) {
    return SavingGoalBudgetItem(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyValue: frequencyValue ?? this.frequencyValue,
    );
  }
}

class SavingGoalDurationOption {
  final String type;
  final String label;
  final int months;
  final int days;
  final String durationText;
  final double monthlySaving;
  final double dailySaving;
  final bool isRecommended;
  final bool preserveCurrentBudget;

  SavingGoalDurationOption({
    required this.type,
    required this.label,
    required this.months,
    required this.days,
    required this.durationText,
    required this.monthlySaving,
    required this.dailySaving,
    required this.isRecommended,
    required this.preserveCurrentBudget,
  });

  factory SavingGoalDurationOption.fromMap(
    Map<String, dynamic> map,
    double fallbackTarget,
    int fallbackMonths,
    int fallbackDays,
  ) {
    final m = (map['months'] as num?)?.toInt() ?? fallbackMonths;
    final days =
        (map['days'] as num?)?.toInt() ??
        (map['daysEstimate'] as num?)?.toInt() ??
        (m > 0 ? m * 30 : fallbackDays);
    final dailySaving = _roundVndUp(
      (map['dailySaving'] as num?)?.toDouble() ??
          (days > 0 ? fallbackTarget / days : 0),
    );
    final type = map['type']?.toString() ?? 'recommended';
    final label = map['label']?.toString() ?? 'Khuyến nghị';
    final normalizedLabel = label.toLowerCase();
    final isKeepBudgetOption =
        normalizedLabel.contains('') ||
        normalizedLabel.contains('giu ngan sach');
    final isRecommended =
        map['isRecommended'] == true ||
        type == 'recommended' ||
        days == fallbackDays;

    return SavingGoalDurationOption(
      type: type,
      label: label,
      months: m,
      days: days,
      durationText:
          map['durationText']?.toString() ??
          SavingGoalProposal._formatDuration(days),
      monthlySaving: _roundVndUp(
        (map['monthlySaving'] as num?)?.toDouble() ??
            (days > 0 ? fallbackTarget / (days / 30) : 0),
      ),
      dailySaving: dailySaving,
      isRecommended: isRecommended,
      preserveCurrentBudget:
          map['preserveCurrentBudget'] == true || isKeepBudgetOption,
    );
  }
}
