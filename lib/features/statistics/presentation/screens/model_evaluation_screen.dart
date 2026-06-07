import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import '../controllers/model_evaluation_controller.dart';
import '../../data/models/model_evaluation_model.dart';

class ModelEvaluationScreen extends GetView<ModelEvaluationController> {
  const ModelEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Obx(() {
          final summary = controller.summary.value;
          final isLoading = controller.isLoading.value;
          final isRunning = controller.isRunningEvaluation.value;
          final isTraining = controller.isTrainingForecasting.value;

          return Column(
            children: [
              AppHeader(
                title: 'AI Model Evaluation',
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'Đánh giá chất lượng AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOverviewCard(summary),
                            const SizedBox(height: 16),
                            _buildForecastingSection(summary?.forecasting),
                            const SizedBox(height: 16),
                            _buildBudgetingSection(summary?.budgeting),
                            const SizedBox(height: 24),
                            _buildTrainForecastingButton(isTraining),
                            const SizedBox(height: 12),
                            _buildManualEvaluateButton(isRunning),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOverviewCard(ModelEvaluationSummaryModel? summary) {
    final hasForecasting =
        summary?.forecasting != null && summary!.forecasting!.evaluatedRuns > 0;
    final hasBudgeting =
        summary?.budgeting != null && summary!.budgeting!.evaluatedRuns > 0;

    if (!hasForecasting && !hasBudgeting) {
      return _buildEmptyOverview();
    }

    final forecastMape = summary.forecasting?.mape;
    final budgetOverrun = summary.budgeting?.overrunRate;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: Colors.white70, size: 20),
              SizedBox(width: 8),
              Text(
                'Tổng quan chất lượng AI',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (hasForecasting)
                Expanded(
                  child: _buildOverviewMetric(
                    'Sai số dự báo',
                    forecastMape != null
                        ? '${forecastMape.toStringAsFixed(1)}%'
                        : 'N/A',
                    _getMapeColor(forecastMape),
                    Icons.timeline,
                  ),
                ),
              if (hasForecasting && hasBudgeting) const SizedBox(width: 16),
              if (hasBudgeting)
                Expanded(
                  child: _buildOverviewMetric(
                    'Vượt ngân sách',
                    budgetOverrun != null
                        ? '${budgetOverrun.toStringAsFixed(1)}%'
                        : 'N/A',
                    _getOverrunColor(budgetOverrun),
                    Icons.account_balance_wallet,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMetric(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.white54, size: 48),
          SizedBox(height: 12),
          Text(
            'Chưa đủ dữ liệu để đánh giá',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hệ thống sẽ tự động đánh giá sau khi kỳ dự báo kết thúc. '
            'Bạn cũng có thể nhấn nút bên dưới để chạy đánh giá thủ công.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastingSection(ForecastingSummaryModel? forecasting) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.timeline, color: Colors.blue, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Đánh giá dự báo chi tiêu',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (forecasting == null || forecasting.evaluatedRuns == 0)
            _buildNoDataRow('Chưa có dự báo nào được đánh giá')
          else ...[
            _buildMetricRow(
              'Số lần đánh giá',
              '${forecasting.evaluatedRuns}',
              Icons.check_circle_outline,
              Colors.green,
            ),
            const SizedBox(height: 10),
            _buildMetricRow(
              'MAE (Sai số tuyệt đối TB)',
              forecasting.mae != null
                  ? AppHelperFunction.formatAmount(forecasting.mae!)
                  : 'N/A',
              Icons.straighten,
              Colors.orange,
            ),
            const SizedBox(height: 10),
            _buildMetricRow(
              'RMSE',
              forecasting.rmse != null
                  ? AppHelperFunction.formatAmount(forecasting.rmse!)
                  : 'N/A',
              Icons.square_foot,
              Colors.deepOrange,
            ),
            const SizedBox(height: 10),
            _buildMetricRow(
              'MAPE (Sai số %)',
              forecasting.mape != null
                  ? '${forecasting.mape!.toStringAsFixed(1)}%'
                  : 'N/A',
              Icons.percent,
              _getMapeColor(forecasting.mape),
            ),
            const SizedBox(height: 10),
            _buildMetricRow(
              'Model đang dùng',
              _formatModelName(forecasting.latestModelName),
              Icons.memory,
              Colors.purple,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBudgetingSection(BudgetingSummaryModel? budgeting) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.green,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Đánh giá gợi ý ngân sách',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (budgeting == null || budgeting.evaluatedRuns == 0)
            _buildNoDataRow('Chưa có gợi ý ngân sách nào được đánh giá')
          else ...[
            _buildMetricRow(
              'Số lần đánh giá',
              '${budgeting.evaluatedRuns}',
              Icons.check_circle_outline,
              Colors.green,
            ),
            const SizedBox(height: 10),
            _buildMetricRow(
              'Tỷ lệ vượt ngân sách',
              budgeting.overrunRate != null
                  ? '${budgeting.overrunRate!.toStringAsFixed(1)}%'
                  : 'N/A',
              Icons.trending_up,
              _getOverrunColor(budgeting.overrunRate),
            ),
            const SizedBox(height: 10),
            _buildMetricRow(
              'Số tiền vượt TB',
              budgeting.averageOverrunAmount != null
                  ? AppHelperFunction.formatAmount(
                      budgeting.averageOverrunAmount!,
                    )
                  : 'N/A',
              Icons.money_off,
              Colors.red,
            ),
            const SizedBox(height: 10),
            _buildMetricRow(
              'Tỷ lệ áp dụng gợi ý',
              budgeting.adoptionRate != null
                  ? '${budgeting.adoptionRate!.toStringAsFixed(1)}%'
                  : 'N/A',
              Icons.thumb_up_outlined,
              Colors.blue,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.text3),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNoDataRow(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.text4, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildManualEvaluateButton(bool isRunning) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isRunning ? null : () => controller.runManualEvaluation(),
        child: isRunning
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_outline, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Chạy đánh giá thủ công',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTrainForecastingButton(bool isTraining) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isTraining ? null : () => controller.trainForecastingModel(),
        child: isTraining
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.model_training, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Train forecasting model',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getMapeColor(double? mape) {
    if (mape == null) return Colors.grey;
    if (mape <= 15) return Colors.greenAccent;
    if (mape <= 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Color _getOverrunColor(double? rate) {
    if (rate == null) return Colors.grey;
    if (rate <= 20) return Colors.greenAccent;
    if (rate <= 40) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  String _formatModelName(String name) {
    switch (name) {
      case 'prophet':
        return 'Prophet';
      case 'gradient_boosting_daily':
        return 'Gradient Boosting';
      case 'fallback_average':
        return 'Trung bình dự phòng';
      default:
        return name;
    }
  }
}
