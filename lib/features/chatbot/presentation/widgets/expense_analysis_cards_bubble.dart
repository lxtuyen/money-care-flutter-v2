import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/data/models/chatbot_expense_analysis_model.dart';
import 'package:money_care/features/chatbot/presentation/widgets/expense_analysis_components.dart';

class ExpenseAnalysisCardsBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const ExpenseAnalysisCardsBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final analysis = ChatbotExpenseAnalysisModel.fromJson(metadata);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (analysis.message.isNotEmpty)
              _IntroMessage(message: analysis.message),
            if (analysis.emptyState != null)
              _InfoCard(
                icon: Iconsax.info_circle_copy,
                title: analysis.emptyState!.title,
                body: analysis.emptyState!.message,
              ),
            if (analysis.overview != null)
              _OverviewCard(overview: analysis.overview!),
            if (analysis.forecast?.currentMonthProjection != null)
              _ForecastCard(forecast: analysis.forecast!),
            _AnomalyCard(items: analysis.anomalies),
            if (analysis.budgetRisk != null)
              _BudgetRiskCard(budgetRisk: analysis.budgetRisk!),
            if (analysis.recommendations.isNotEmpty)
              _RecommendationCard(items: analysis.recommendations),
          ],
        ),
      ),
    );
  }
}

class _IntroMessage extends StatelessWidget {
  final String message;

  const _IntroMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderSecondary),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 14, height: 1.35, color: colors.textPrimary),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final ChatbotOverviewModel overview;

  const _OverviewCard({required this.overview});

  @override
  Widget build(BuildContext context) {
    final statusColor = getExpenseAnalysisStatusColor(overview.cashFlowTrend);
    return ExpenseAnalysisCardShell(
      icon: Iconsax.chart_2_copy,
      title: 'Tổng quan',
      accentColor: statusColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ExpenseAnalysisMetricBlock(
                  label: 'Sức khỏe',
                  value: '${overview.financialHealthScore}/100',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ExpenseAnalysisMetricBlock(
                  label: 'Dự báo chi',
                  value: AppHelperFunction.formatAmount(overview.monthlyForecast),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (overview.expenseTotal != null || overview.incomeTotal != null)
            Row(
              children: [
                if (overview.expenseTotal != null)
                  Expanded(
                    child: ExpenseAnalysisMetricBlock(
                      label: 'Đã chi',
                      value: AppHelperFunction.formatAmount(overview.expenseTotal!),
                    ),
                  ),
                if (overview.expenseTotal != null &&
                    overview.incomeTotal != null)
                  const SizedBox(width: 8),
                if (overview.incomeTotal != null)
                  Expanded(
                    child: ExpenseAnalysisMetricBlock(
                      label: 'Thu nhập',
                      value: AppHelperFunction.formatAmount(overview.incomeTotal!),
                    ),
                  ),
              ],
            ),
          if (overview.summary.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              overview.summary,
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
          ],
        ],
      ),
    );
  }
}


class _ForecastCard extends StatelessWidget {
  final ChatbotForecastModel forecast;

  const _ForecastCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final projection = forecast.currentMonthProjection!;
    return ExpenseAnalysisCardShell(
      icon: Iconsax.activity_copy,
      title: 'Dự báo',
      accentColor: getExpenseAnalysisStatusColor(projection.riskLevel),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (projection.totalForecast != null)
                Expanded(
                  child: ExpenseAnalysisMetricBlock(
                    label: 'Cuối tháng',
                    value: AppHelperFunction.formatAmount(projection.totalForecast!),
                  ),
                ),
              if (projection.totalForecast != null &&
                  projection.predictedRemainingAmount != null)
                const SizedBox(width: 8),
              if (projection.predictedRemainingAmount != null)
                Expanded(
                  child: ExpenseAnalysisMetricBlock(
                    label: 'Còn phát sinh',
                    value: AppHelperFunction.formatAmount(projection.predictedRemainingAmount!),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ExpenseAnalysisStatusPill(label: 'Rủi ro', value: projection.riskLevel),
              const SizedBox(width: 8),
              ExpenseAnalysisStatusPill(
                label: 'Tin cậy',
                value: '${(projection.confidence * 100).round()}%',
              ),
            ],
          ),
          if (projection.modelNotes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              projection.modelNotes,
              style: const TextStyle(fontSize: 12.5, height: 1.35),
            ),
          ],
          if (forecast.riskWindows.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...forecast.riskWindows
                .take(2)
                .map(
                  (item) => ExpenseAnalysisListRow(
                    title: _formatPeriod(item.periodStart, item.periodEnd),
                    value: item.predictedAmount == null
                        ? item.riskLevel
                        : AppHelperFunction.formatAmount(item.predictedAmount!),
                    subtitle: item.reason,
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _AnomalyCard extends StatelessWidget {
  final List<ChatbotAnomalyModel> items;

  const _AnomalyCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return ExpenseAnalysisCardShell(
      icon: Iconsax.warning_2_copy,
      title: 'Bất thường',
      accentColor: items.isEmpty ? Colors.green : Colors.orange,
      child: items.isEmpty
          ? const Text(
              'Chưa phát hiện giao dịch bất thường trong kỳ này.',
              style: TextStyle(fontSize: 13),
            )
          : Column(
              children: items.take(3).map((item) {
                return ExpenseAnalysisListRow(
                  title: item.categoryName,
                  value: AppHelperFunction.formatAmount(item.amount),
                  subtitle: '${_formatDate(item.date)} - ${item.reason}',
                );
              }).toList(),
            ),
    );
  }
}

class _BudgetRiskCard extends StatelessWidget {
  final ChatbotBudgetRiskModel budgetRisk;

  const _BudgetRiskCard({required this.budgetRisk});

  @override
  Widget build(BuildContext context) {
    return ExpenseAnalysisCardShell(
      icon: Iconsax.wallet_3_copy,
      title: 'Rủi ro ngân sách',
      accentColor: getExpenseAnalysisStatusColor(budgetRisk.riskLevel),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (budgetRisk.message.isNotEmpty)
            Text(
              budgetRisk.message,
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
          if (budgetRisk.items.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...budgetRisk.items.take(3).map((item) {
              final progress = item.limitAmount > 0
                  ? (item.spentAmount / item.limitAmount).clamp(0.0, 1.0)
                  : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpenseAnalysisListRow(
                      title: item.categoryName,
                      value: item.limitAmount > 0
                          ? '${AppHelperFunction.formatAmount(item.spentAmount)} / ${AppHelperFunction.formatAmount(item.limitAmount)}'
                          : item.status,
                      subtitle: '',
                    ),
                    if (item.limitAmount > 0)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.grey.withValues(alpha: 0.16),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            getExpenseAnalysisStatusColor(item.status),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final List<ChatbotRecommendationModel> items;

  const _RecommendationCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return ExpenseAnalysisCardShell(
      icon: Iconsax.lamp_charge_copy,
      title: 'Gợi ý hành động',
      accentColor: Colors.teal,
      child: Column(
        children: items.take(3).map((item) {
          return ExpenseAnalysisListRow(
            title: item.title,
            value: '',
            subtitle: item.description,
            leadingDotColor: getExpenseAnalysisStatusColor(item.severity),
          );
        }).toList(),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ExpenseAnalysisCardShell(
      icon: icon,
      title: title,
      accentColor: Colors.blueGrey,
      child: Text(body, style: const TextStyle(fontSize: 13, height: 1.35)),
    );
  }
}

String _formatPeriod(String start, String end) {
  if (start.isEmpty && end.isEmpty) return 'Khoảng rủi ro';
  if (start.isEmpty) return end;
  if (end.isEmpty) return start;
  return '$start - $end';
}

String _formatDate(String value) {
  if (value.length >= 10) return value.substring(0, 10);
  return value;
}
