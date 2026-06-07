// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';

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
            if (data.currentMonthProjection != null) ...[
              const SizedBox(height: 14),
              _MonthlyProjectionPanel(projection: data.currentMonthProjection!),
            ] else if (data.forecasting != null) ...[
              const SizedBox(height: 14),
              _ForecastingPanel(forecasting: data.forecasting!),
            ],
            /*if (data.nextMonthForecast != null) ...[
              const SizedBox(height: 14),
              _NextMonthForecastPanel(forecast: data.nextMonthForecast!),
            ],*/
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
            //...data.insights.map((insight) => _InsightPanel(insight: insight)),
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

  TransactionEntity _getOrCreateTransaction(
    AnomalyModel anomaly,
    TransactionController txController,
  ) {
    TransactionEntity? found;
    for (final tx in txController.allTransactions) {
      if (tx.id == anomaly.transactionId) {
        found = tx;
        break;
      }
    }
    if (found != null) {
      return found;
    }

    DateTime? parsedDate = DateTime.tryParse(anomaly.date);
    return TransactionEntity(
      id: anomaly.transactionId,
      amount: anomaly.amount.toInt(),
      type: 'expense',
      transactionDate: parsedDate,
      note: anomaly.reason,
      category: CategoryEntity(
        id: null,
        name: anomaly.categoryName,
        icon: _guessCategoryIcon(anomaly.categoryName),
        type: 'expense',
      ),
    );
  }

  String _guessCategoryIcon(String categoryName) {
    final name = categoryName.trim().toLowerCase();
    if (name.contains('chợ') ||
        name.contains('siêu thị') ||
        name.contains('rau') ||
        name.contains('thực phẩm')) {
      return '🥬';
    }
    if (name.contains('ăn') ||
        name.contains('uống') ||
        name.contains('nhà hàng') ||
        name.contains('cà phê') ||
        name.contains('cafe')) {
      return '🍽️';
    }
    if (name.contains('di chuyển') ||
        name.contains('xe') ||
        name.contains('bus') ||
        name.contains('grab') ||
        name.contains('taxi') ||
        name.contains('xăng')) {
      return '🚌';
    }
    if (name.contains('mua sắm') ||
        name.contains('shopping') ||
        name.contains('áo') ||
        name.contains('quần') ||
        name.contains('giày')) {
      return '🛒';
    }
    if (name.contains('giải trí') ||
        name.contains('phim') ||
        name.contains('game') ||
        name.contains('du lịch') ||
        name.contains('chơi')) {
      return '🎬';
    }
    if (name.contains('làm đẹp') ||
        name.contains('spa') ||
        name.contains('tóc') ||
        name.contains('mỹ phẩm')) {
      return '💄';
    }
    if (name.contains('sức khỏe') ||
        name.contains('y tế') ||
        name.contains('thuốc') ||
        name.contains('bác sĩ') ||
        name.contains('khám')) {
      return '💊';
    }
    if (name.contains('từ thiện') || name.contains('quyên góp')) {
      return '❤️';
    }
    if (name.contains('hóa đơn') ||
        name.contains('điện') ||
        name.contains('nước') ||
        name.contains('internet') ||
        name.contains('cước')) {
      return '🧾';
    }
    if (name.contains('nhà') ||
        name.contains('phòng') ||
        name.contains('thuê') ||
        name.contains('sửa')) {
      return '🏠';
    }
    if (name.contains('người thân') ||
        name.contains('gia đình') ||
        name.contains('bố') ||
        name.contains('mẹ') ||
        name.contains('con')) {
      return '👪';
    }
    if (name.contains('đầu tư') ||
        name.contains('chứng khoán') ||
        name.contains('vàng')) {
      return '📈';
    }
    if (name.contains('học') ||
        name.contains('sách') ||
        name.contains('trường') ||
        name.contains('khóa học') ||
        name.contains('giáo dục')) {
      return '📚';
    }
    return '⚠️';
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    final appController = Get.find<AppController>();

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
          Obx(() {
            final _ = transactionController.transactionChangedCount.value;
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: anomalies.length,
              itemBuilder: (context, index) {
                final a = anomalies[index];
                final tx = _getOrCreateTransaction(a, transactionController);
                return TransactionItem(
                  item: tx,
                  isShowDate: true,
                  isShowDivider: index < anomalies.length - 1,
                  onTap: () {
                    final userId = appController.userId.value ?? 0;
                    TransactionDetail.show(
                      context,
                      item: tx,
                      userId: userId,
                      isExpense: true,
                    );
                  },
                  detail: Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 12,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            a.reason,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
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


BoxDecoration _panelDecoration(Color color) {
  return BoxDecoration(
    color: color.withValues(alpha: 0.07),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: color.withValues(alpha: 0.22)),
  );
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
