import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

class CoupleSpendingAlertsSection extends StatelessWidget {
  final CoupleController controller;

  const CoupleSpendingAlertsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final report = controller.coupleReport.value;
      if (report == null) return const SizedBox.shrink();

      final alerts = report.alerts;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          AppSectionHeading(
            title: 'Cảnh Báo Chi Tiêu',
            showActionButton: report.unreadAlertCount > 0,
            buttonTitle: '${report.unreadAlertCount} chưa đọc',
            onPressed: null,
          ),
          const SizedBox(height: 8),
          if (alerts.isEmpty)
            const AppEmptyState(
              message: 'Không có cảnh báo chi tiêu nào.',
            )
          else
            ...alerts.map(
              (alert) => _AlertCard(controller: controller, alert: alert),
            ),
        ],
      );
    });
  }
}

class _AlertCard extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;

  const _AlertCard({required this.controller, required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = alert.severity == 'high'
        ? Colors.red
        : alert.severity == 'medium'
        ? Colors.orange
        : Colors.blueGrey;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_rounded, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (!alert.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(alert.message),
          const SizedBox(height: 6),
          Text(
            AppHelperFunction.formatAmount(alert.amount),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: alert.isRead
                    ? null
                    : () => controller.markAlertRead(alert.id),
                child: const Text('Đã đọc'),
              ),
              TextButton(
                onPressed: alert.status == 'resolved'
                    ? null
                    : () => controller.resolveAlert(alert.id),
                child: const Text('Xử lý'),
              ),
              TextButton(
                onPressed: () =>
                    controller.sendAlertFeedback(alert.id, 'correct'),
                child: const Text('Đúng'),
              ),
              TextButton(
                onPressed: () =>
                    controller.sendAlertFeedback(alert.id, 'ignored'),
                child: const Text('Bỏ qua'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
