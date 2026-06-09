import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/widgets/button/app_outline_button.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/features/chatbot/presentation/widgets/budget_recommendation_bubble.dart';

class RecommendationItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int proposalHashCode;
  final StagedChange? stagedChange;
  final VoidCallback onUndoStage;
  final VoidCallback onStageRemove;
  final VoidCallback onStageApply;
  final void Function(BuildContext) onShowModifySheet;

  const RecommendationItemCard({
    super.key,
    required this.item,
    required this.proposalHashCode,
    required this.stagedChange,
    required this.onUndoStage,
    required this.onStageRemove,
    required this.onStageApply,
    required this.onShowModifySheet,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final statsCtrl = Get.find<StatisticsController>();
    final planCtrl = Get.isRegistered<SpendingPlanController>()
        ? Get.find<SpendingPlanController>()
        : null;

    final originalRecId = item['recommendationId']?.toString() ?? '';
    final uniqueRecId = '${originalRecId}_$proposalHashCode';

    final categoryId = item['categoryId'] as int?;
    final recommendedLimit =
        (item['recommendedLimitAmount'] as num?)?.toDouble() ?? 0;
    final predictedSpend =
        (item['predictedSpendAmount'] as num?)?.toDouble() ?? 0;
    final canApply = item['canApply'] as bool? ?? false;

    final isStaged = stagedChange != null;

    double currentLimit = (item['currentLimitAmount'] as num?)?.toDouble() ?? 0;
    if (planCtrl != null) {
      final activePlan = planCtrl.activePlan.value;
      if (activePlan != null && categoryId != null) {
        final expense = activePlan.estimatedExpenses.firstWhereOrNull(
          (e) => e.categoryId == categoryId,
        );
        if (expense != null) {
          currentLimit = expense.monthlyLimit > 0
              ? expense.monthlyLimit
              : expense.amount;
        }
      }
    }

    double displayLimit = currentLimit;
    if (isStaged && stagedChange!.action == StagedAction.applied) {
      displayLimit = stagedChange!.customAmount ?? recommendedLimit;
    }

    final isSameLimit = displayLimit == recommendedLimit;
    final isStagedRemoved =
        isStaged && stagedChange!.action == StagedAction.removed;

    return Obx(() {
      final isSubmitted = statsCtrl.submittedFeedbackIds.contains(uniqueRecId);
      final isSending = statsCtrl.sendingFeedbackIds.contains(uniqueRecId);

      return Opacity(
        opacity: isStagedRemoved ? 0.55 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surfaceBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isStagedRemoved
                  ? AppColors.error.withValues(alpha: 0.3)
                  : isStaged
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : colors.borderSecondary,
              width: isStaged ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            item['categoryName'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isStaged) ...[
                          const SizedBox(width: 8),
                          _buildStagedBadge(context, stagedChange!.action),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isStaged)
                    InkWell(
                      onTap: onUndoStage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.undo_rounded,
                          size: 14,
                          color: AppColors.info,
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: isSending ? null : onStageRemove,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colors.textMuted.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCompactVal(
                      context,
                      'Hiện tại',
                      currentLimit > 0
                          ? AppHelperFunction.formatAmount(currentLimit)
                          : 'Chưa đặt',
                      stagedValue:
                          (isStaged &&
                              stagedChange!.action == StagedAction.applied &&
                              currentLimit != displayLimit)
                          ? AppHelperFunction.formatAmount(displayLimit)
                          : null,
                      isStrikethrough: isStagedRemoved,
                      color: isStagedRemoved ? colors.textMuted : null,
                    ),
                  ),
                  Expanded(
                    child: _buildCompactVal(
                      context,
                      'Dự báo',
                      AppHelperFunction.formatAmount(predictedSpend),
                      color: AppColors.expense,
                    ),
                  ),
                  if (!isSameLimit)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCompactVal(
                            context,
                            'Đề xuất',
                            AppHelperFunction.formatAmount(recommendedLimit),
                            color: AppColors.primary,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (isStagedRemoved) ...[
                // No action buttons when staged for removal
              ] else if (isStaged &&
                  stagedChange!.action == StagedAction.applied) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppOutlineButton(
                      label: '',
                      onPressed: isSending
                          ? null
                          : () => onShowModifySheet(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.borderSecondary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        minimumSize: const Size(64, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Sửa',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else if (isSubmitted) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.primary,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Đã áp dụng',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppOutlineButton(
                      label: '',
                      onPressed: isSending
                          ? null
                          : () => onShowModifySheet(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.borderSecondary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        minimumSize: const Size(64, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Sửa',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else if (!canApply) ...[
                const SizedBox(height: 8),
                Text(
                  'Vui lòng tạo kế hoạch chi tiêu trước',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: colors.textMuted,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isSameLimit)
                      PrimaryButton(
                        label: 'Sửa',
                        onPressed: isSending
                            ? null
                            : () => onShowModifySheet(context),
                        icon: const Icon(Icons.edit_rounded, size: 12),
                        height: 28,
                        width: 64,
                        fontSize: 11,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      )
                    else
                      AppOutlineButton(
                        label: '',
                        onPressed: isSending
                            ? null
                            : () => onShowModifySheet(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.textPrimary,
                          side: BorderSide(color: colors.borderSecondary),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          minimumSize: const Size(64, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_rounded, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Sửa',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!isSameLimit) ...[
                      const SizedBox(width: 8),
                      PrimaryButton(
                        label: 'Áp dụng',
                        onPressed: isSending ? null : onStageApply,
                        icon: const Icon(Icons.check_rounded, size: 12),
                        height: 28,
                        width: 64,
                        fontSize: 11,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCompactVal(
    BuildContext context,
    String label,
    String value, {
    String? stagedValue,
    bool isStrikethrough = false,
    bool isBold = false,
    Color? color,
  }) {
    final colors = AppThemeColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9.5, color: colors.textSecondary),
        ),
        const SizedBox(height: 2),
        if (stagedValue != null) ...[
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
              decoration: TextDecoration.lineThrough,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            stagedValue,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ] else
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? colors.textPrimary,
              decoration: isStrikethrough ? TextDecoration.lineThrough : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildStagedBadge(BuildContext context, StagedAction action) {
    final isApplied = action == StagedAction.applied;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isApplied
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApplied
                ? Icons.hourglass_empty_rounded
                : Icons.remove_circle_outline_rounded,
            color: isApplied ? AppColors.primary : AppColors.error,
            size: 10,
          ),
          const SizedBox(width: 2),
          Text(
            isApplied ? 'Chờ áp dụng' : 'Sẽ bị xóa',
            style: TextStyle(
              fontSize: 9,
              color: isApplied ? AppColors.primary : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
