import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/data/models/chatbot_expense_analysis_model.dart';
import 'package:money_care/features/chatbot/presentation/widgets/expense_analysis_components.dart';

class ExpenseAnalysisCardsBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final VoidCallback? onCategoryBreakdownTap;

  const ExpenseAnalysisCardsBubble({
    super.key,
    required this.metadata,
    this.onCategoryBreakdownTap,
  });

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
            if (analysis.anomalies.isNotEmpty)
              _AnomalyCard(items: analysis.anomalies),
            if (analysis.budgetRisk != null)
              _BudgetRiskCard(budgetRisk: analysis.budgetRisk!),
            if (onCategoryBreakdownTap != null && analysis.emptyState == null)
              _CategoryBreakdownButton(
                onTap: onCategoryBreakdownTap!,
              ),
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
            ...budgetRisk.items
                .where((item) =>
                    // Đã vượt ngân sách
                    item.spentAmount > item.limitAmount ||
                    // Dự báo sẽ vượt
                    (item.forecastAmount != null &&
                        item.forecastAmount! > item.limitAmount))
                .take(3)
                .map((item) {
              final progress = item.limitAmount > 0
                  ? (item.spentAmount / item.limitAmount).clamp(0.0, 1.0)
                  : 0.0;
              final forecastProgress = item.forecastAmount != null &&
                      item.limitAmount > 0
                  ? (item.forecastAmount! / item.limitAmount).clamp(0.0, 1.0)
                  : null;
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
                    if (item.spentAmount > item.limitAmount &&
                        item.limitAmount > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Đã vượt: ',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade400,
                            ),
                          ),
                          Text(
                            AppHelperFunction.formatAmount(
                                item.spentAmount - item.limitAmount),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ] else if (item.forecastAmount != null &&
                        item.forecastAmount! > item.limitAmount &&
                        item.limitAmount > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Dự báo cuối tháng: ',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            AppHelperFunction.formatAmount(item.forecastAmount!),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: forecastProgress != null &&
                                      forecastProgress > 1.0
                                  ? Colors.red.shade400
                                  : Colors.orange.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
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

String _formatDate(String value) {
  if (value.length >= 10) return value.substring(0, 10);
  return value;
}

class _CategoryBreakdownButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CategoryBreakdownButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A2744), const Color(0xFF1E293B)]
                    : [const Color(0xFFE8F0FE), const Color(0xFFF0F4FF)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
                    : const Color(0xFF3B82F6).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.chart_1_copy,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF60A5FA)
                      : const Color(0xFF2563EB),
                ),
                const SizedBox(width: 8),
                Text(
                  'Xem chi tiết từng danh mục',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF60A5FA)
                        : const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: isDark
                      ? const Color(0xFF60A5FA).withValues(alpha: 0.6)
                      : const Color(0xFF2563EB).withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
