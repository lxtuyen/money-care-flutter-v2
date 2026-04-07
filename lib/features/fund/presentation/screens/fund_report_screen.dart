import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/fund/data/models/fund_report_model.dart';
import 'package:money_care/features/fund/presentation/controllers/fund_controller.dart';

class FundReportScreen extends StatefulWidget {
  const FundReportScreen({super.key});

  @override
  State<FundReportScreen> createState() => _FundReportScreenState();
}

class _FundReportScreenState extends State<FundReportScreen> {
  final controller = Get.find<FundController>();
  late final int fundId;
  final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );
  final dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    fundId = Get.arguments as int;
    if (controller.fundReport.value?.fundId != fundId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadFundReport(fundId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.text1),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Báo cáo quỹ',
          style: TextStyle(
            color: AppColors.text1,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingReport.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final report = controller.fundReport.value;
        if (report == null) {
          return const Center(
            child: Text(
              'Không có dữ liệu báo cáo',
              style: TextStyle(color: AppColors.text3),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(report),
              const SizedBox(height: 16),
              _buildBudgetCard(report),
              const SizedBox(height: 16),
              _buildStatsCard(report),
              const SizedBox(height: 16),
              if (report.categoryBreakdown.isNotEmpty) ...[
                _buildCategoryBreakdown(report),
                const SizedBox(height: 16),
              ],
              _buildTimeCard(report),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(FundReportModel report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.linearGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            report.isTargetAchieved ? '🎉' : '📊',
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 8),
          Text(
            report.fundName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          if (report.startDate != null && report.endDate != null)
            Text(
              '${dateFormatter.format(report.startDate!)} - ${dateFormatter.format(report.endDate!)}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          const SizedBox(height: 16),
          _buildProgressCircle(report),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(FundReportModel report) {
    final pct = (report.targetCompletionPercentage / 100).clamp(0.0, 1.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: pct,
                strokeWidth: 8,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Text(
                '${report.targetCompletionPercentage}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hoàn thành mục tiêu',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              report.isTargetAchieved ? 'Đạt mục tiêu ✓' : 'Chưa đạt mục tiêu',
              style: TextStyle(
                color: report.isTargetAchieved
                    ? const Color(0xFF52D113)
                    : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetCard(FundReportModel report) {
    return _Card(
      title: 'Ngân sách',
      child: Column(
        children: [
          _InfoRow(
            label: 'Ngân sách',
            value: currencyFormatter.format(report.balance),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Đã chi tiêu',
            value: currencyFormatter.format(report.totalSpent),
            valueColor: report.isOverBudget ? AppColors.error : AppColors.text1,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Còn lại',
            value: currencyFormatter.format(report.remainingBudget),
            valueColor: report.remainingBudget < 0
                ? AppColors.error
                : AppColors.success,
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sử dụng ngân sách',
                    style: TextStyle(fontSize: 12, color: AppColors.text4),
                  ),
                  Text(
                    '${report.balanceUsagePercentage}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: report.isOverBudget
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (report.balanceUsagePercentage / 100).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: AppColors.borderSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    report.isOverBudget ? AppColors.error : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (report.isOverBudget) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_rounded, size: 14, color: AppColors.error),
                  SizedBox(width: 4),
                  Text(
                    'Đã vượt ngân sách',
                    style: TextStyle(fontSize: 12, color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsCard(FundReportModel report) {
    return _Card(
      title: 'Thống kê',
      child: Row(
        children: [
          Expanded(
            child: _StatBox(
              icon: Icons.receipt_long_rounded,
              label: 'Giao dịch',
              value: '${report.totalTransactions}',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatBox(
              icon: Icons.trending_up_rounded,
              label: 'TB/giao dịch',
              value: currencyFormatter.format(report.averageTransactionAmount),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(FundReportModel report) {
    return _Card(
      title: 'Chi tiêu theo danh mục',
      child: Column(
        children: report.categoryBreakdown.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cat.categoryName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.text2,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormatter.format(cat.totalSpent),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          '${cat.transactionCount} giao dịch',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.text4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (cat.percentage / 100).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: AppColors.borderSecondary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCategoryColor(
                              report.categoryBreakdown.indexOf(cat),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${cat.percentage}%',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.text4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeCard(FundReportModel report) {
    return _Card(
      title: 'Thời gian',
      child: Row(
        children: [
          Expanded(
            child: _StatBox(
              icon: Icons.calendar_today_rounded,
              label: 'Số ngày',
              value: '${report.durationDays} ngày',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatBox(
              icon: Icons.today_rounded,
              label: 'TB/ngày',
              value: currencyFormatter.format(report.dailyAverageSpending),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index) {
    const colors = [
      AppColors.primary,
      AppColors.secondaryOrange,
      AppColors.success,
      AppColors.warning,
      AppColors.secondaryNavyBlue,
      AppColors.info,
    ];
    return colors[index % colors.length];
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.text3)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.text1,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatBox({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text1,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.text4),
          ),
        ],
      ),
    );
  }
}
