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

class BudgetTrackingSection extends StatelessWidget {
  const BudgetTrackingSection({super.key});

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
            if (isCurrentMonth) ...[
              _BudgetSummaryCard(
                plannedIncome: stats.totalAmount,
                totalLimit: controller.totalLimit,
                totalSpent: (controller.totalByType.value?.expenseTotal ?? 0).toDouble(),
                totalForecast: controller.totalForecast > 0 ? controller.totalForecast : null,
                forecastedSaving: controller.forecastedSaving,
                savingBudget: controller.savingBudget,
                savingSpent: controller.savingSpent,
                anomalyCount: controller.anomalyCount,
                onViewDetail: onViewDetail,
              ),
              const SizedBox(height: 12),
            ],
            if (anomalies.isNotEmpty) ...[
              AnomaliesPanel(anomalies: anomalies),
              const SizedBox(height: 12),
            ],
            ...filteredExpenses.entries.map((entry) {
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
          ],
        ),
      );
    });
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  final double plannedIncome;
  final double totalLimit;
  final double totalSpent;
  final double? totalForecast;
  final double forecastedSaving;
  final double savingBudget;
  final double savingSpent;
  final int anomalyCount;
  final VoidCallback? onViewDetail;

  const _BudgetSummaryCard({
    required this.plannedIncome,
    required this.totalLimit,
    required this.totalSpent,
    required this.totalForecast,
    required this.forecastedSaving,
    required this.savingBudget,
    required this.savingSpent,
    this.anomalyCount = 0,
    this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);
    final savingColor = forecastedSaving >= 0
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
            plannedIncome,
            themeColors.textSecondary,
          ),
          const SizedBox(height: 8),
          _row(
            context,
            themeColors,
            '- Tổng ngân sách',
            totalLimit,
            themeColors.textSecondary,
          ),
          const SizedBox(height: 8),
          _row(
            context,
            themeColors,
            '- Đã chi',
            totalSpent,
            themeColors.textSecondary,
          ),
          if (totalForecast != null) ...[
            const SizedBox(height: 8),
            _row(
              context,
              themeColors,
              '- Dự báo cuối tháng',
              totalForecast!,
              const Color(0xFFF59E0B),
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
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
                AppHelperFunction.formatAmount(forecastedSaving),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: savingColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (savingBudget > 0) ...[
            const SizedBox(height: 8),
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
                  '${AppHelperFunction.formatAmount(savingSpent)} / ${AppHelperFunction.formatAmount(savingBudget)}',
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
                  AppHelperFunction.formatAmount((savingBudget - savingSpent).clamp(0.0, double.infinity)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (forecastedSaving < (savingBudget - savingSpent)) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.expense.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.expense.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.expense,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tiết kiệm dự kiến thấp hơn mức cần sẽ ảnh hưởng đến mục tiêu!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.expense,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          if (anomalyCount > 0) ...[
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
                    '$anomalyCount giao dịch',
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

  Widget _row(
    BuildContext context,
    AppThemeColors themeColors,
    String label,
    double amount,
    Color? valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: themeColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          AppHelperFunction.formatAmount(amount),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: valueColor ?? themeColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
