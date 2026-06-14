import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_alert_card.dart';

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
              (alert) => CoupleAlertCard(controller: controller, alert: alert),
            ),
        ],
      );
    });
  }
}
