import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/statistics/presentation/widgets/anomalies_panel.dart';
import 'package:money_care/features/statistics/presentation/widgets/estimated_expense_budget_group_card.dart';

class BudgetTrackingSection extends StatelessWidget {
  final SpendingPlanStatsEntity stats;
  final Map<String, List<EstimatedExpenseEntity>> groupedExpenses;
  final List<BudgetExceedPredictionModel> exceedPredictions;
  final int anomalyCount;
  final List<AnomalyModel> anomalies;
  final bool isLoadingAnalytics;
  final VoidCallback? onViewDetail;

  const BudgetTrackingSection({
    super.key,
    required this.stats,
    required this.groupedExpenses,
    this.exceedPredictions = const [],
    this.anomalyCount = 0,
    this.anomalies = const [],
    this.isLoadingAnalytics = false,
    this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final statisticsController = Get.find<StatisticsController>();
    final selMonth = statisticsController.selectedMonth.value;
    final daysInMonth = DateTime(selMonth.year, selMonth.month + 1, 0).day;
    final now = DateTime.now();
    final isCurrentMonth = selMonth.year == now.year && selMonth.month == now.month;

    final predictionMap = <String, BudgetExceedPredictionModel>{
      for (final p in exceedPredictions) p.categoryName.toLowerCase(): p,
    };

    // Tính tổng từ các danh mục
    double totalLimit = 0;
    double totalSpent = 0;
    double totalForecast = 0;

    for (final entry in groupedExpenses.entries) {
      final expenses = entry.value;
      for (final e in expenses) {
        final limit = e.monthlyLimit > 0
            ? e.monthlyLimit
            : _monthlyizedAmount(e, daysInMonth);
        totalLimit += limit;
        totalSpent += e.spentThisMonth;
      }
      final pred = predictionMap[entry.key.toLowerCase()];
      if (pred != null) {
        totalForecast += pred.totalForecast;
      }
    }

    final plannedIncome = stats.totalAmount;
    final forecastedSaving = totalForecast > 0
        ? plannedIncome - totalForecast
        : plannedIncome - totalSpent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stats.estimatedExpenses.isEmpty)
            const AppEmptyState(
              message: 'Chưa có khoản theo dõi ngân sách nào.',
            )
          else ...[
            // Section heading
            const AppSectionHeading(
              title: 'Tổng quan ngân sách tháng này',
              showActionButton: false,
            ),
            const SizedBox(height: 12),
            if (isLoadingAnalytics) ...[
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
              // Card tổng quan
              _BudgetSummaryCard(
                plannedIncome: plannedIncome,
                totalLimit: totalLimit,
                totalSpent: totalSpent,
                totalForecast: totalForecast > 0 ? totalForecast : null,
                forecastedSaving: forecastedSaving,
                anomalyCount: anomalyCount,
                onViewDetail: onViewDetail,
              ),
              const SizedBox(height: 12),
            ],
            // Anomalies panel (nếu có)
            if (anomalies.isNotEmpty) ...[
              AnomaliesPanel(anomalies: anomalies),
              const SizedBox(height: 12),
            ],
            // Danh sách các danh mục
            ...groupedExpenses.entries.map((entry) {
              final prediction = predictionMap[entry.key.toLowerCase()];
              return EstimatedExpenseBudgetGroupCard(
                categoryName: entry.key,
                daysInMonth: daysInMonth,
                expenses: entry.value,
                exceedPrediction: prediction,
              );
            }),
          ],
        ],
      ),
    );
  }

  double _monthlyizedAmount(EstimatedExpenseEntity expense, int daysInMonth) {
    final v = expense.frequencyValue <= 0 ? 1 : expense.frequencyValue;
    switch (expense.frequencyType.toLowerCase()) {
      case 'daily':
        return expense.amount * v * daysInMonth;
      case 'weekly':
        return expense.amount * v * (daysInMonth / 7);
      default:
        return expense.amount * v;
    }
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  final double plannedIncome;
  final double totalLimit;
  final double totalSpent;
  final double? totalForecast;
  final double forecastedSaving;
  final int anomalyCount;
  final VoidCallback? onViewDetail;

  const _BudgetSummaryCard({
    required this.plannedIncome,
    required this.totalLimit,
    required this.totalSpent,
    required this.totalForecast,
    required this.forecastedSaving,
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
          if (onViewDetail != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewDetail,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Chi tiết'),
              ),
            ),
          ],
          const SizedBox(height: 12),
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
