import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
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
            if (data.currentMonthProjection != null) ...[
              const SizedBox(height: 14),
              _MonthlyProjectionPanel(projection: data.currentMonthProjection!),
            ] else if (data.forecasting != null) ...[
              const SizedBox(height: 14),
              _ForecastingPanel(forecasting: data.forecasting!),
            ],
            if (data.nextMonthForecast != null) ...[
              const SizedBox(height: 14),
              _NextMonthForecastPanel(forecast: data.nextMonthForecast!),
            ],
            if (data.aiBudgeting != null) ...[
              const SizedBox(height: 14),
              _AiBudgetingPanel(aiBudgeting: data.aiBudgeting!),
            ],
            if (data.goalAchievement != null) ...[
              const SizedBox(height: 14),
              _GoalAchievementPanel(summary: data.goalAchievement!),
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

class _GoalAchievementPanel extends StatelessWidget {
  final GoalAchievementPredictionSummaryModel summary;

  const _GoalAchievementPanel({required this.summary});

  @override
  Widget build(BuildContext context) {
    final predictions = [...summary.predictions]..sort(_compareGoalRisk);
    final visiblePredictions = predictions.take(3).toList();
    final color = _summaryRiskColor(summary);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.flag_circle_outlined,
            title: 'Dự báo mục tiêu tiết kiệm',
            color: color,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _GoalSummaryTile(
                  label: 'Đúng hạn',
                  value: summary.onTrackGoals.toString(),
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _GoalSummaryTile(
                  label: 'Rủi ro',
                  value: summary.atRiskGoals.toString(),
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _GoalSummaryTile(
                  label: 'Lệch tiến độ',
                  value: summary.offTrackGoals.toString(),
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          if (visiblePredictions.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...visiblePredictions.map(
              (prediction) => _GoalPredictionRow(prediction: prediction),
            ),
            if (predictions.length > visiblePredictions.length)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${predictions.length - visiblePredictions.length} mục tiêu khác',
                  style: const TextStyle(
                    color: AppColors.text3,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _GoalPredictionRow extends StatelessWidget {
  final GoalAchievementPredictionModel prediction;

  const _GoalPredictionRow({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(prediction.riskLevel);
    final source = _goalSourceText(
      prediction.supportingData['savingVelocitySource']?.toString(),
    );

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  prediction.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _InlineBadge(
                icon: Icons.flag_circle_outlined,
                color: color,
                text: _goalStatusText(prediction.status),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _MetricRow(
            label: 'Còn thiếu',
            value: AppHelperFunction.formatAmount(prediction.remainingAmount),
            valueColor: AppColors.text1,
          ),
          _MetricRow(
            label: 'Hạn mục tiêu',
            value: prediction.deadline != null
                ? _formatGoalDate(prediction.deadline!)
                : 'Chưa đặt',
            valueColor: AppColors.text2,
          ),
          _MetricRow(
            label: 'Dự kiến hoàn thành',
            value: prediction.predictedCompletionDate != null
                ? _formatGoalDate(prediction.predictedCompletionDate!)
                : 'Chưa đủ dữ liệu',
            valueColor: color,
          ),
          _MetricRow(
            label: 'Cần tiết kiệm',
            value:
                '${AppHelperFunction.formatAmount(prediction.requiredMonthlySavingRate)}/tháng • ${AppHelperFunction.formatAmount(prediction.requiredDailySavingRate)}/ngày',
            valueColor: AppColors.text1,
          ),
          if (source.isNotEmpty)
            _MetricRow(
              label: 'Nguồn dữ liệu',
              value: source,
              valueColor: AppColors.info,
            ),
          if (prediction.recommendedActions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                prediction.recommendedActions.first.message,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.text3,
                  height: 1.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GoalSummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _GoalSummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text3,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
              value: AppHelperFunction.formatAmount(data.monthlyForecast),
              valueColor: AppColors.expense,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyProjectionPanel extends StatelessWidget {
  final ForecastingModel projection;

  const _MonthlyProjectionPanel({required this.projection});

  @override
  Widget build(BuildContext context) {
    final isWeeklyExpanded = false.obs;
    final isCategoriesExpanded = false.obs;

    final color = _riskColor(projection.riskLevel);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.donut_large_rounded,
            title:
                'Dự phòng tháng ${projection.targetMonth}/${projection.targetYear}',
            color: color,
          ),
          const SizedBox(height: 12),
          _MetricRow(
            label: 'Đã chi (Thực tế)',
            value: AppHelperFunction.formatAmount(projection.actualAmount),
            valueColor: AppColors.text1,
          ),
          _MetricRow(
            label: 'Dự báo chi phần còn lại',
            value: AppHelperFunction.formatAmount(
              projection.predictedRemainingAmount,
            ),
            valueColor: AppColors.text2,
          ),
          _MetricRow(
            label: 'Tổng dự phòng cả tháng',
            value: AppHelperFunction.formatAmount(projection.totalForecast),
            valueColor: color,
          ),
          _MetricRow(
            label: 'Độ tin cậy mô hình',
            value: '${(projection.confidence * 100).round()}%',
            valueColor: AppColors.info,
          ),
          _MetricRow(
            label: 'Mức độ rủi ro',
            value: projection.riskLevel == 'high'
                ? 'CAO'
                : (projection.riskLevel == 'medium' ? 'TRUNG BÌNH' : 'THẤP'),
            valueColor: color,
          ),
          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  final total = projection.totalForecast;
                  if (total <= 0) return Container(color: Colors.grey.shade200);
                  final actualPct = projection.actualAmount / total;
                  return Row(
                    children: [
                      if (actualPct > 0)
                        Expanded(
                          flex: (actualPct * 100).round(),
                          child: Container(color: color),
                        ),
                      if (actualPct < 1)
                        Expanded(
                          flex: ((1 - actualPct) * 100).round(),
                          child: Container(
                            color: color.withValues(alpha: 0.25),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            projection.modelNotes,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.text3,
              height: 1.35,
            ),
          ),

          // Risk windows
          if (projection.riskWindows.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...projection.riskWindows.map((rw) => _RiskWindowCard(rw: rw)),
          ],

          const Divider(height: 24),

          // Expandable Weekly Forecasts
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: isWeeklyExpanded.toggle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Xem dự báo theo tuần',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text2,
                        ),
                      ),
                      Icon(
                        isWeeklyExpanded.value
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 18,
                        color: AppColors.text3,
                      ),
                    ],
                  ),
                ),
                if (isWeeklyExpanded.value) ...[
                  const SizedBox(height: 8),
                  ...projection.weeklyForecasts.map(
                    (w) => _WeeklyForecastRow(w: w),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 24),

          // Expandable Category Forecasts
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: isCategoriesExpanded.toggle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Xem dự báo theo danh mục',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text2,
                        ),
                      ),
                      Icon(
                        isCategoriesExpanded.value
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 18,
                        color: AppColors.text3,
                      ),
                    ],
                  ),
                ),
                if (isCategoriesExpanded.value) ...[
                  const SizedBox(height: 8),
                  ...projection.categoryForecasts.map(
                    (c) => _CategoryMonthlyForecastRow(c: c),
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

class _WeeklyForecastRow extends StatelessWidget {
  final WeeklyForecastModel w;

  const _WeeklyForecastRow({required this.w});

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(w.riskLevel);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Tuần ${w.weekIndex} (${w.periodStart.substring(5)} - ${w.periodEnd.substring(5)})',
              style: const TextStyle(fontSize: 11, color: AppColors.text2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Dự báo: ${AppHelperFunction.formatAmount(w.predictedAmount)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (w.actualAmount > 0)
                Text(
                  'Đã chi: ${AppHelperFunction.formatAmount(w.actualAmount)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              w.riskLevel == 'high'
                  ? 'CAO'
                  : (w.riskLevel == 'medium' ? 'T.BÌNH' : 'THẤP'),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryMonthlyForecastRow extends StatelessWidget {
  final CategoryForecastModel c;

  const _CategoryMonthlyForecastRow({required this.c});

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(c.riskLevel ?? 'low');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              c.categoryName,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.text2,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Dự báo: ${AppHelperFunction.formatAmount(c.predictedAmount)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (c.actualAmount != null && c.actualAmount! > 0)
                Text(
                  'Đã chi: ${AppHelperFunction.formatAmount(c.actualAmount!)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              (c.riskLevel ?? 'low') == 'high'
                  ? 'CAO'
                  : ((c.riskLevel ?? 'low') == 'medium' ? 'T.BÌNH' : 'THẤP'),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskWindowCard extends StatelessWidget {
  final ForecastRiskWindowModel rw;

  const _RiskWindowCard({required this.rw});

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(rw.riskLevel);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo rủi ro chi tiêu (${rw.periodStart.substring(5)} - ${rw.periodEnd.substring(5)})',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rw.reason,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextMonthForecastPanel extends StatelessWidget {
  final ForecastingModel forecast;

  const _NextMonthForecastPanel({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final topCategories = forecast.categoryForecasts.take(3).toList();
    final color = AppColors.success;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.next_plan_outlined,
            title:
                'Dự báo tháng sau (${forecast.targetMonth}/${forecast.targetYear})',
            color: color,
          ),
          const SizedBox(height: 12),
          _MetricRow(
            label: 'Tổng chi tiêu dự kiến',
            value: AppHelperFunction.formatAmount(forecast.totalForecast),
            valueColor: color,
          ),
          _MetricRow(
            label: 'Độ tin cậy',
            value: '${(forecast.confidence * 100).round()}%',
            valueColor: AppColors.info,
          ),
          const SizedBox(height: 8),
          Text(
            forecast.modelNotes,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
          if (topCategories.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Danh mục chi tiêu chính dự báo:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.text2,
              ),
            ),
            const SizedBox(height: 4),
            ...topCategories.map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      c.categoryName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.text2,
                      ),
                    ),
                    Text(
                      AppHelperFunction.formatAmount(c.predictedAmount),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
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
            value: AppHelperFunction.formatAmount(
              aiBudgeting.recommendedTotalBudget,
            ),
            valueColor: AppColors.success,
          ),
          _MetricRow(
            label: 'Tiết kiệm kỳ vọng',
            value: AppHelperFunction.formatAmount(
              aiBudgeting.expectedSavingsAmount,
            ),
            valueColor: AppColors.info,
          ),
          _MetricRow(
            label: 'Mục tiêu tiết kiệm',
            value: AppHelperFunction.formatAmount(
              aiBudgeting.targetSavingsAmount,
            ),
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
                '${a.date}: Chi ${AppHelperFunction.formatAmount(a.amount)} ở mục "${a.categoryName}". Lý do: ${a.reason}',
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
            AppHelperFunction.formatAmount(item.predictedAmount),
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
                        'Đề xuất: ${AppHelperFunction.formatAmount(item.recommendedLimitAmount)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_actionTypeText(item.actionType)} ${AppHelperFunction.formatAmount(item.adjustmentAmount.abs())}',
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

String _formatGoalDate(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  final day = parsed.day.toString().padLeft(2, '0');
  final month = parsed.month.toString().padLeft(2, '0');
  return '$day/$month/${parsed.year}';
}

Color _summaryRiskColor(GoalAchievementPredictionSummaryModel summary) {
  if (summary.offTrackGoals > 0) return AppColors.error;
  if (summary.atRiskGoals > 0) return AppColors.warning;
  return AppColors.success;
}

int _compareGoalRisk(
  GoalAchievementPredictionModel a,
  GoalAchievementPredictionModel b,
) {
  final riskDiff = _riskRank(b.riskLevel) - _riskRank(a.riskLevel);
  if (riskDiff != 0) return riskDiff;

  final daysDiff = (b.daysDifference ?? -9999) - (a.daysDifference ?? -9999);
  if (daysDiff != 0) return daysDiff;

  final aDeadline = DateTime.tryParse(a.deadline ?? '')?.millisecondsSinceEpoch;
  final bDeadline = DateTime.tryParse(b.deadline ?? '')?.millisecondsSinceEpoch;
  return (aDeadline ?? 9999999999999).compareTo(bDeadline ?? 9999999999999);
}

int _riskRank(String riskLevel) {
  return switch (riskLevel) {
    'high' => 3,
    'medium' => 2,
    _ => 1,
  };
}

String _goalStatusText(String status) {
  return switch (status) {
    'completed' => 'Hoàn thành',
    'on_track' => 'Đúng hạn',
    'slightly_at_risk' || 'at_risk' => 'Rủi ro',
    'off_track' || 'overdue' || 'unlikely' => 'Lệch tiến độ',
    _ => 'Theo dõi',
  };
}

String _goalSourceText(String? source) {
  return switch (source) {
    'profile_average_savings' => 'Hồ sơ tài chính',
    'spending_plan_capacity' => 'Kế hoạch chi tiêu',
    'net_balance_fallback' => 'Giao dịch',
    'goal_contribution_history' => 'Lịch sử nạp mục tiêu',
    _ => '',
  };
}
