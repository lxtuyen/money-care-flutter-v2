import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/transaction/data/models/transaction_filter_dto.dart';

class StatisticsExportSheet extends StatelessWidget {
  const StatisticsExportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final userController = Get.find<UserController>();
    final statisticsController = Get.find<StatisticsController>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'statistics.exportTitle'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            'statistics.exportEmailNote'.tr.replaceAll(
              '@email',
              userController.user.value?.email ?? '...',
            ),
            style: const TextStyle(color: AppColors.text3),
          )),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildExportOption(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'PDF',
                  color: Colors.red,
                  onTap: () => _handleExport(appController, statisticsController, 'pdf'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildExportOption(
                  icon: Icons.table_chart_rounded,
                  label: 'CSV',
                  color: Colors.green,
                  onTap: () => _handleExport(appController, statisticsController, 'csv'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(16),
          color: color.withValues(alpha: 0.05),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExport(
    AppController appController,
    StatisticsController statisticsController,
    String format,
  ) async {
    Get.back();
    final userId = appController.userId.value;
    if (userId == null) return;

    final filterDto = TransactionFilterDto(
      startDate: statisticsController.currentStartDate.toIso8601String(),
      endDate: statisticsController.currentEndDate.toIso8601String(),
    );

    await Get.find<TransactionController>().exportReport(
      userId,
      filterDto,
      format,
    );
  }
}
