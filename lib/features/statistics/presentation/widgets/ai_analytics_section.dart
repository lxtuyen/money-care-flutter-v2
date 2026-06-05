import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';

class AiAnalyticsSection extends StatelessWidget {
  const AiAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatisticsController>();

    return Obx(() {
      final isLoading = controller.isLoadingAnalytics.value;
      final error = controller.analyticsError.value;
      final data = controller.analyticsData.value;

      if (isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: _LoadingPanel(),
        );
      }

      if (error.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: _ErrorPanel(error: error),
        );
      }

      if (data == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OverviewPanel(data: data),
            if (data.forecasting != null) ...[
              const SizedBox(height: 14),
              _ForecastingPanel(forecasting: data.forecasting!),
            ],
            if (data.aiBudgeting != null) ...[
              const SizedBox(height: 14),
              _AiBudgetingPanel(aiBudgeting: data.aiBudgeting!),
            ],
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'AI Insights & Phân tích',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text1,
                ),
              ),
            ),
            ...data.insights.map((insight) => _InsightPanel(insight: insight)),
            if (data.anomalies.isNotEmpty) ...[
              const SizedBox(height: 12),
              _AnomaliesPanel(anomalies: data.anomalies),
            ],
          ],
        ),
      );
    });
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _panelDecoration(AppColors.info),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'AI đang phân tích dữ liệu tài chính của bạn...',
            style: TextStyle(fontSize: 14, color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  final String error;

  const _ErrorPanel({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(AppColors.error),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Không thể kết nối dịch vụ phân tích AI: $error',
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewPanel extends StatelessWidget {
  final AnalyticsModel data;

  const _OverviewPanel({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6EAF8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                _ScoreCircle(score: data.financialHealthScore),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sức khỏe tài chính AI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text(
                            'Xu hướng dòng tiền: ',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.text3,
                            ),
                          ),
                          _TrendBadge(trend: data.cashFlowTrend),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Đánh giá: ${_scoreEvaluation(data.financialHealthScore)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFD6EAF8)),
            _MetricRow(
              label: 'Dự báo chi tiêu 30 ngày tới',
              value:
                  '${AppHelperFunction.formatAmount(data.monthlyForecast)} VND',
              valueColor: AppColors.expense,
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastingPanel extends StatelessWidget {
  final ForecastingModel forecasting;

  const _ForecastingPanel({required this.forecasting});

  @override
  Widget build(BuildContext context) {
    final topCategories = forecasting.categoryForecasts.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(AppColors.info),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.timeline_rounded,
            title: 'Forecasting Engine',
            color: AppColors.info,
          ),
          const SizedBox(height: 12),
          _MetricRow(
            label: 'Mô hình',
            value: forecasting.method,
            valueColor: AppColors.text1,
          ),
          _MetricRow(
            label: 'Độ tin cậy',
            value: '${(forecasting.confidence * 100).round()}%',
            valueColor: AppColors.info,
          ),
          const SizedBox(height: 8),
          Text(
            forecasting.modelNotes,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
          if (topCategories.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...topCategories.map((item) => _CategoryForecastRow(item: item)),
          ],
        ],
      ),
    );
  }
}

class _AiBudgetingPanel extends StatelessWidget {
  final AiBudgetingModel aiBudgeting;

  const _AiBudgetingPanel({required this.aiBudgeting});

  @override
  Widget build(BuildContext context) {
    final topItems = aiBudgeting.items.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(AppColors.success),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.account_balance_wallet_outlined,
            title: 'AI Budgeting',
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _MetricRow(
            label: 'Ngân sách đề xuất',
            value:
                '${AppHelperFunction.formatAmount(aiBudgeting.recommendedTotalBudget)} VND',
            valueColor: AppColors.success,
          ),
          _MetricRow(
            label: 'Tiết kiệm kỳ vọng',
            value:
                '${AppHelperFunction.formatAmount(aiBudgeting.expectedSavingsAmount)} VND',
            valueColor: AppColors.info,
          ),
          _MetricRow(
            label: 'Mục tiêu tiết kiệm',
            value:
                '${AppHelperFunction.formatAmount(aiBudgeting.targetSavingsAmount)} VND',
            valueColor: AppColors.text1,
          ),
          _MetricRow(
            label: 'Chiến lược',
            value: _strategyText(aiBudgeting.strategy),
            valueColor: AppColors.text1,
          ),
          _MetricRow(
            label: 'Độ tin cậy',
            value: '${(aiBudgeting.confidence * 100).round()}%',
            valueColor: AppColors.info,
          ),
          const SizedBox(height: 8),
          Text(
            aiBudgeting.summary,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
          if (topItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...topItems.map((item) => _BudgetRecommendationRow(item: item)),
          ],
        ],
      ),
    );
  }
}

class _InsightPanel extends StatelessWidget {
  final InsightModel insight;

  const _InsightPanel({required this.insight});

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(insight.severity);
    final icon = switch (insight.severity) {
      'success' => Icons.check_circle_outline,
      'warning' => Icons.warning_amber_rounded,
      _ => Icons.info_outline,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _panelDecoration(color),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color == AppColors.warning
                          ? const Color(0xFFC07000)
                          : color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.text2,
                      height: 1.4,
                    ),
                  ),
                  if (insight.evidence.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Bằng chứng: ${insight.evidence}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnomaliesPanel extends StatelessWidget {
  final List<AnomalyModel> anomalies;

  const _AnomaliesPanel({required this.anomalies});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _panelDecoration(AppColors.error),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.report_problem_outlined,
            title: 'Giao dịch chi tiêu bất thường',
            color: AppColors.error,
          ),
          const SizedBox(height: 8),
          ...anomalies.map(
            (a) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${a.date}: Chi ${AppHelperFunction.formatAmount(a.amount)} VND ở mục "${a.categoryName}". Lý do: ${a.reason}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  final int score;

  const _ScoreCircle({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);

    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: score / 100.0,
              strokeWidth: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Text(
                'Điểm',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final String trend;

  const _TrendBadge({required this.trend});

  @override
  Widget build(BuildContext context) {
    final (icon, color, text) = switch (trend) {
      'improving' => (Icons.trending_up, AppColors.success, 'Tăng trưởng'),
      'worsening' => (Icons.trending_down, AppColors.error, 'Giảm sút'),
      _ => (Icons.trending_flat, AppColors.info, 'Ổn định'),
    };

    return _InlineBadge(icon: icon, color: color, text: text);
  }
}

class _InlineBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _InlineBadge({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.text3,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryForecastRow extends StatelessWidget {
  final CategoryForecastModel item;

  const _CategoryForecastRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final trendText = switch (item.trend) {
      'increasing' => 'tăng',
      'decreasing' => 'giảm',
      _ => 'ổn định',
    };

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${item.categoryName} ($trendText)',
              style: const TextStyle(fontSize: 12, color: AppColors.text2),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${AppHelperFunction.formatAmount(item.predictedAmount)} VND',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.expense,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetRecommendationRow extends StatelessWidget {
  final AiBudgetRecommendationItemModel item;

  const _BudgetRecommendationRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatisticsController>();
    final color = _riskColor(item.riskLevel);

    return Obx(() {
      final isSubmitted = controller.submittedFeedbackIds.contains(
        item.recommendationId,
      );
      final isSending = controller.sendingFeedbackIds.contains(
        item.recommendationId,
      );

      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.categoryName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Đề xuất: ${AppHelperFunction.formatAmount(item.recommendedLimitAmount)} VND',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_actionTypeText(item.actionType)} ${AppHelperFunction.formatAmount(item.adjustmentAmount.abs())} VND',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _actionTypeColor(item.actionType),
                        ),
                      ),
                    ],
                  ),
                ),
                _InlineBadge(
                  icon: Icons.circle,
                  color: color,
                  text: item.riskLevel,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _TinyInfoBadge(
                  icon: Icons.shield_outlined,
                  text: '${item.riskBefore} → ${item.riskAfter}',
                  color: _riskColor(item.riskAfter),
                ),
                _TinyInfoBadge(
                  icon: Icons.tune_rounded,
                  text: _elasticityText(item.elasticity),
                  color: AppColors.info,
                ),
                _TinyInfoBadge(
                  icon: Icons.verified_outlined,
                  text: '${(item.confidence * 100).round()}%',
                  color: AppColors.success,
                ),
              ],
            ),
            if (item.reasonCodes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.reasonCodes.take(3).map(_reasonCodeText).join(' • '),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.text4,
                  height: 1.3,
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (isSubmitted)
              const _FeedbackRecordedBadge()
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FeedbackActionChip(
                    icon: Icons.check_rounded,
                    label: 'Áp dụng',
                    isLoading: isSending,
                    onTap: () => controller.sendBudgetRecommendationFeedback(
                      item,
                      'accepted',
                      finalLimitAmount: item.recommendedLimitAmount,
                    ),
                  ),
                  _FeedbackActionChip(
                    icon: Icons.edit_rounded,
                    label: 'Sửa',
                    isLoading: isSending,
                    onTap: () =>
                        _showModifyFeedbackSheet(context, controller, item),
                  ),
                  _FeedbackActionChip(
                    icon: Icons.close_rounded,
                    label: 'Không phù hợp',
                    isLoading: isSending,
                    onTap: () => controller.sendBudgetRecommendationFeedback(
                      item,
                      'rejected',
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Future<void> _showModifyFeedbackSheet(
    BuildContext context,
    StatisticsController controller,
    AiBudgetRecommendationItemModel item,
  ) async {
    final amountController = TextEditingController(
      text: item.recommendedLimitAmount.round().toString(),
    );

    await Get.bottomSheet<void>(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sửa đề xuất ngân sách',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Hạn mức mong muốn',
                  suffixText: 'VND',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(amountController.text);
                        if (amount == null || amount <= 0) {
                          AppHelperFunction.showErrorSnackBar(
                            'Vui lòng nhập số tiền hợp lệ',
                          );
                          return;
                        }
                        Get.back<void>();
                        controller.sendBudgetRecommendationFeedback(
                          item,
                          'modified',
                          finalLimitAmount: amount,
                        );
                      },
                      child: const Text('Lưu phản hồi'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );

    amountController.dispose();
  }
}

class _FeedbackActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _FeedbackActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: isLoading
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, size: 16, color: AppColors.text2),
      label: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      onPressed: isLoading ? null : onTap,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _FeedbackRecordedBadge extends StatelessWidget {
  const _FeedbackRecordedBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
        SizedBox(width: 5),
        Text(
          'Đã ghi nhận',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _TinyInfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _TinyInfoBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _panelDecoration(Color color) {
  return BoxDecoration(
    color: color.withValues(alpha: 0.07),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: color.withValues(alpha: 0.22)),
  );
}

Color _scoreColor(int score) {
  if (score >= 80) return AppColors.success;
  if (score >= 50) return AppColors.warning;
  return AppColors.error;
}

String _scoreEvaluation(int score) {
  if (score >= 85) return 'Xuất sắc';
  if (score >= 70) return 'Tốt';
  if (score >= 50) return 'Trung bình';
  return 'Cần cải thiện ngay';
}

Color _severityColor(String severity) {
  return switch (severity) {
    'success' => AppColors.success,
    'warning' => AppColors.warning,
    _ => AppColors.info,
  };
}

Color _riskColor(String riskLevel) {
  return switch (riskLevel) {
    'high' => AppColors.error,
    'medium' => AppColors.warning,
    _ => AppColors.success,
  };
}

String _strategyText(String strategy) {
  return switch (strategy) {
    'aggressive_saving' => 'Ưu tiên tiết kiệm',
    'conservative' => 'Thận trọng',
    'stability_first' => 'Ổn định trước',
    _ => 'Cân bằng',
  };
}

String _actionTypeText(String actionType) {
  return switch (actionType) {
    'increase' => 'Tăng',
    'decrease' => 'Giảm',
    'create' => 'Tạo mới',
    _ => 'Giữ gần mức cũ',
  };
}

Color _actionTypeColor(String actionType) {
  return switch (actionType) {
    'increase' => AppColors.warning,
    'decrease' => AppColors.success,
    _ => AppColors.text3,
  };
}

String _elasticityText(String elasticity) {
  return switch (elasticity) {
    'low' => 'Khó điều chỉnh',
    'high' => 'Dễ điều chỉnh',
    _ => 'Điều chỉnh nhẹ',
  };
}

String _reasonCodeText(String code) {
  return switch (code) {
    'forecast_above_current_limit' => 'Dự báo cao hơn hạn mức',
    'forecast_below_current_limit' => 'Dự báo thấp hơn hạn mức',
    'saving_goal_pressure' => 'Ưu tiên mục tiêu tiết kiệm',
    'low_savings_rate' => 'Tỷ lệ tiết kiệm thấp',
    'high_expense_volatility' => 'Chi tiêu biến động',
    'poor_budget_discipline' => 'Kỷ luật ngân sách thấp',
    'essential_category_protected' => 'Bảo vệ nhóm thiết yếu',
    'user_feedback_buffer_applied' => 'Áp dụng phản hồi trước',
    'user_rejection_respected' => 'Tôn trọng phản hồi từ chối',
    'model_uncertainty_buffer' => 'Thêm buffer do sai số mô hình',
    'high_elasticity_cut' => 'Cắt nhóm linh hoạt trước',
    'insufficient_data_conservative' => 'Dữ liệu chưa đủ',
    _ => code.replaceAll('_', ' '),
  };
}
