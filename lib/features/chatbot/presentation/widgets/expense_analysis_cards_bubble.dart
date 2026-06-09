import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/data/models/chatbot_expense_analysis_model.dart';

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
    final statusColor = _statusColor(overview.cashFlowTrend);
    return _CardShell(
      icon: Iconsax.chart_2_copy,
      title: 'Tổng quan',
      accentColor: statusColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: 'Sức khỏe',
                  value: '${overview.financialHealthScore}/100',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBlock(
                  label: 'Dự báo chi',
                  value: _formatAmount(overview.monthlyForecast),
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
                    child: _MetricBlock(
                      label: 'Đã chi',
                      value: _formatAmount(overview.expenseTotal!),
                    ),
                  ),
                if (overview.expenseTotal != null &&
                    overview.incomeTotal != null)
                  const SizedBox(width: 8),
                if (overview.incomeTotal != null)
                  Expanded(
                    child: _MetricBlock(
                      label: 'Thu nhập',
                      value: _formatAmount(overview.incomeTotal!),
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
    return _CardShell(
      icon: Iconsax.activity_copy,
      title: 'Dự báo',
      accentColor: _statusColor(projection.riskLevel),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (projection.totalForecast != null)
                Expanded(
                  child: _MetricBlock(
                    label: 'Cuối tháng',
                    value: _formatAmount(projection.totalForecast!),
                  ),
                ),
              if (projection.totalForecast != null &&
                  projection.predictedRemainingAmount != null)
                const SizedBox(width: 8),
              if (projection.predictedRemainingAmount != null)
                Expanded(
                  child: _MetricBlock(
                    label: 'Còn phát sinh',
                    value: _formatAmount(projection.predictedRemainingAmount!),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatusPill(label: 'Rủi ro', value: projection.riskLevel),
              const SizedBox(width: 8),
              _StatusPill(
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
                  (item) => _ListRow(
                    title: _formatPeriod(item.periodStart, item.periodEnd),
                    value: item.predictedAmount == null
                        ? item.riskLevel
                        : _formatAmount(item.predictedAmount!),
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
    return _CardShell(
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
                return _ListRow(
                  title: item.categoryName,
                  value: _formatAmount(item.amount),
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
    return _CardShell(
      icon: Iconsax.wallet_3_copy,
      title: 'Rủi ro ngân sách',
      accentColor: _statusColor(budgetRisk.riskLevel),
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
                    _ListRow(
                      title: item.categoryName,
                      value: item.limitAmount > 0
                          ? '${_formatAmount(item.spentAmount)} / ${_formatAmount(item.limitAmount)}'
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
                            _statusColor(item.status),
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
    return _CardShell(
      icon: Iconsax.lamp_charge_copy,
      title: 'Gợi ý hành động',
      accentColor: Colors.teal,
      child: Column(
        children: items.take(3).map((item) {
          return _ListRow(
            title: item.title,
            value: '',
            subtitle: item.description,
            leadingDotColor: _statusColor(item.severity),
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
    return _CardShell(
      icon: icon,
      title: title,
      accentColor: Colors.blueGrey,
      child: Text(body, style: const TextStyle(fontSize: 13, height: 1.35)),
    );
  }
}

class _CardShell extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;
  final Widget child;

  const _CardShell({
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 17, color: accentColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  final String label;
  final String value;

  const _MetricBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: colors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color? leadingDotColor;

  const _ListRow({
    required this.title,
    required this.value,
    required this.subtitle,
    this.leadingDotColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: leadingDotColor ?? AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (value.isNotEmpty)
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                  ],
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _StatusPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatusPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(value);
    String displayValue = value;
    final normalized = value.toLowerCase();
    if (normalized == 'high' || normalized == 'danger' || normalized == 'critical') {
      displayValue = 'Cao';
    } else if (normalized == 'medium' || normalized == 'warning') {
      displayValue = 'Trung bình';
    } else if (normalized == 'low' || normalized == 'good' || normalized == 'success' || normalized == 'normal') {
      displayValue = 'Thấp';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $displayValue',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

String _formatAmount(double amount) {
  return AppHelperFunction.formatAmount(amount);
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

Color _statusColor(String value) {
  final normalized = value.toLowerCase();
  if (['danger', 'critical', 'high', 'worsening'].contains(normalized)) {
    return Colors.redAccent;
  }
  if (['warning', 'medium', 'near_limit'].contains(normalized)) {
    return Colors.orange;
  }
  if (['good', 'success', 'low', 'stable', 'normal'].contains(normalized)) {
    return Colors.green;
  }
  return Colors.blueGrey;
}
