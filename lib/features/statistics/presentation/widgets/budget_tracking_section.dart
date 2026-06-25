import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/statistics/presentation/widgets/anomalies_panel.dart';
import 'package:money_care/features/statistics/presentation/widgets/estimated_expense_budget_group_card.dart';
import 'package:money_care/features/habit_commitments/domain/entities/habit_commitment_entity.dart';
import 'package:money_care/features/statistics/presentation/widgets/unpaid_recurring_panel.dart';

class BudgetTrackingSection extends StatefulWidget {
  const BudgetTrackingSection({super.key});

  @override
  State<BudgetTrackingSection> createState() => _BudgetTrackingSectionState();
}

class _BudgetTrackingSectionState extends State<BudgetTrackingSection> {
  static const int _maxCollapsedItems = 2;
  bool _isBudgetExpanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatisticsController>();

    return Obx(() {
      final stats = controller.spendingPlanStats;
      if (stats == null || stats.estimatedExpenses.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AppEmptyState(
            message: 'Chưa có khoản theo dõi ngân sách nào.',
          ),
        );
      }

      final filteredExpenses = controller.filteredExpenses;
      final isCurrentMonth = controller.isCurrentMonth;
      final anomalies = controller.anomalies;
      final predictionMap = controller.predictionMap;
      final categorySpentMap = controller.categorySpentMap;
      final daysInMonth = controller.daysInMonth;

      final onViewDetail = stats.estimatedExpenses.length > 5
          ? () {
              Get.toNamed(
                RoutePath.spendingPlanDetail,
                arguments: stats.planId,
              );
            }
          : null;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionHeading(
              title: 'Tổng quan ngân sách tháng này',
              showActionButton: false,
            ),
            const SizedBox(height: 12),
            if (controller.isLoadingAnalytics.value) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Đang phân tích chi tiêu bằng AI...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (isCurrentMonth && controller.totalForecast > 0) ...[
              _BudgetSummaryCard(
                plannedIncome: stats.totalAmount,
                totalLimit: controller.totalLimit,
                totalSpent: (controller.totalByType.value?.expenseTotal ?? 0).toDouble(),
                totalForecast: controller.totalForecast > 0 ? controller.totalForecast : null,
                totalFixedForecast: controller.totalFixedForecast,
                totalFlexibleForecast: controller.totalFlexibleForecast,
                forecastedSaving: controller.forecastedSaving,
                savingBudget: controller.savingBudget,
                savingSpent: controller.savingSpent,
                anomalyCount: controller.anomalyCount,
                habitCutSavings: controller.totalHabitSavings,
                commitments: controller.habitCommitments,
                onViewDetail: onViewDetail,
              ),
              const SizedBox(height: 12),
            ],
            if ((controller.analyticsData.value?.unpaidRecurring ?? []).isNotEmpty) ...[
             /* UnpaidRecurringPanel(
                items: controller.analyticsData.value!.unpaidRecurring,
              ),
              const SizedBox(height: 12),*/
            ],
            if (anomalies.isNotEmpty) ...[
              AnomaliesPanel(anomalies: anomalies),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 12),
            ...() {
              final entries = filteredExpenses.entries.toList();
              final visibleEntries = _isBudgetExpanded
                  ? entries
                  : entries.take(_maxCollapsedItems).toList();
              final hiddenCount = entries.length - _maxCollapsedItems;

              return [
                ...visibleEntries.map((entry) {
                  final prediction = predictionMap[entry.key.toLowerCase()];
                  final actualSpent = categorySpentMap[entry.key.toLowerCase()] ?? 0.0;
                  return EstimatedExpenseBudgetGroupCard(
                    categoryName: entry.key,
                    daysInMonth: daysInMonth,
                    expenses: entry.value,
                    exceedPrediction: prediction,
                    actualSpent: actualSpent,
                  );
                }),
                if (entries.length > _maxCollapsedItems)
                  GestureDetector(
                    onTap: () => setState(() => _isBudgetExpanded = !_isBudgetExpanded),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isBudgetExpanded
                                ? 'Thu gọn'
                                : 'Xem thêm ($hiddenCount)',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _isBudgetExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
              ];
            }(),
          ],
        ),
      );
    });
  }
}

class _BudgetSummaryCard extends StatefulWidget {
  final double plannedIncome;
  final double totalLimit;
  final double totalSpent;
  final double? totalForecast;
  final double totalFixedForecast;
  final double totalFlexibleForecast;
  final double forecastedSaving;
  final double savingBudget;
  final double savingSpent;
  final int anomalyCount;
  final double habitCutSavings;
  final List<HabitCommitmentEntity> commitments;
  final VoidCallback? onViewDetail;

  const _BudgetSummaryCard({
    required this.plannedIncome,
    required this.totalLimit,
    required this.totalSpent,
    required this.totalForecast,
    required this.totalFixedForecast,
    required this.totalFlexibleForecast,
    required this.forecastedSaving,
    required this.savingBudget,
    required this.savingSpent,
    this.anomalyCount = 0,
    this.habitCutSavings = 0,
    this.commitments = const [],
    this.onViewDetail,
  });

  @override
  State<_BudgetSummaryCard> createState() => _BudgetSummaryCardState();
}

class _BudgetSummaryCardState extends State<_BudgetSummaryCard> {
  bool _commitmentExpanded = false;

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final savingColor = widget.forecastedSaving >= 0
        ? AppColors.primary
        : AppColors.expense;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            context,
            themeColors,
            '- Thu nhập kế hoạch',
            widget.plannedIncome,
            themeColors.textSecondary,
          ),
          const SizedBox(height: 8),
          _row(
            context,
            themeColors,
            '- Tổng ngân sách',
            widget.totalLimit,
            themeColors.textSecondary,
          ),
          const SizedBox(height: 8),
          _row(
            context,
            themeColors,
            '- Đã chi',
            widget.totalSpent,
            themeColors.textSecondary,
          ),
          if (widget.totalForecast != null) ...[
            const SizedBox(height: 8),
            _row(
              context,
              themeColors,
              '- Dự báo cuối tháng',
              widget.totalForecast!,
              const Color(0xFFF59E0B),
            ),
            if (widget.totalFixedForecast > 0) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: _row(
                  context,
                  themeColors,
                  'Cố định',
                  widget.totalFixedForecast,
                  const Color(0xFF6366F1),
                  isSubRow: true,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: _row(
                  context,
                  themeColors,
                  'Linh hoạt',
                  widget.totalFlexibleForecast,
                  const Color(0xFF10B981),
                  isSubRow: true,
                ),
              ),
            ],
          ],
          if (widget.totalForecast != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),
            // Savings row (always primary color)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiết kiệm dự kiến',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: savingColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  AppHelperFunction.formatAmount(widget.forecastedSaving),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: savingColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            // Inline commitment details
            if (widget.habitCutSavings > 0 && widget.commitments.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildCommitmentSection(context, themeColors),
            ],
            // Breakdown sub-line when commitments exist
            if (widget.habitCutSavings > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '+ Cắt giảm ${AppHelperFunction.formatAmount(widget.habitCutSavings)} = ',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${AppHelperFunction.formatAmount(widget.forecastedSaving + widget.habitCutSavings)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ],
          if (widget.savingBudget > 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đã tiết kiệm',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${AppHelperFunction.formatAmount(widget.savingSpent)} / ${AppHelperFunction.formatAmount(widget.savingBudget)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Còn lại cần cho mục tiêu',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  AppHelperFunction.formatAmount((widget.savingBudget - widget.savingSpent).clamp(0.0, double.infinity)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
          if (widget.anomalyCount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chi tiêu bất thường',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.expense,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.expense.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.anomalyCount} giao dịch',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.expense,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommitmentSection(
    BuildContext context,
    AppThemeColors themeColors,
  ) {
    final commitments = widget.commitments;
    final showExpand = commitments.length > 1;
    final visible = _commitmentExpanded
        ? commitments
        : commitments.take(1).toList();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.income.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.income.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...visible.map((c) => _buildCommitmentRow(context, themeColors, c)),
          if (showExpand)
            GestureDetector(
              onTap: () =>
                  setState(() => _commitmentExpanded = !_commitmentExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _commitmentExpanded
                          ? 'Thu gọn'
                          : 'Xem thêm (${commitments.length - 1})',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.income,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      _commitmentExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppColors.income,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommitmentRow(
    BuildContext context,
    AppThemeColors themeColors,
    HabitCommitmentEntity c,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = c.isExceeded ? Colors.red : Colors.green;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: habit name + avg price + projected→committed + progress
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        c.habitName,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (c.avgPerTransaction > 0) ...[
                      const SizedBox(width: 6),
                      Text(
                        '~${AppHelperFunction.formatAmount(c.avgPerTransaction)}/lần',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // ~~projected~~ → committed
              if (c.projectedCount > 0) ...[
                Text(
                  '${c.projectedCount}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                    decoration: TextDecoration.lineThrough,
                    decorationColor:
                        isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(Icons.arrow_forward_rounded,
                    size: 10,
                    color: AppColors.income),
                const SizedBox(width: 3),
              ],
              Text(
                '${c.committedCount} lần',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.income,
                ),
              ),
              const SizedBox(width: 8),
              // Current / committed badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${c.currentCount}/${c.committedCount}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor.shade600,
                  ),
                ),
              ),
            ],
          ),
          // Progress bar
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: c.progressPercent,
              minHeight: 3,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                statusColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    AppThemeColors themeColors,
    String label,
    double amount,
    Color? valueColor, {
    bool isSubRow = false,
  }) {
    final textStyle = isSubRow
        ? Theme.of(context).textTheme.labelSmall
        : Theme.of(context).textTheme.bodySmall;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle?.copyWith(
            color: isSubRow ? valueColor?.withValues(alpha: 0.7) : themeColors.textSecondary,
            fontWeight: isSubRow ? FontWeight.w500 : FontWeight.w600,
          ),
        ),
        Text(
          AppHelperFunction.formatAmount(amount),
          style: textStyle?.copyWith(
            color: valueColor ?? themeColors.textPrimary,
            fontWeight: isSubRow ? FontWeight.w600 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
