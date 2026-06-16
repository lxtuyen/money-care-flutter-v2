import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_alert_simple_card.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_alert_structured_card.dart';

/// Dispatcher — chọn đúng widget con dựa vào [alert.type].
class CoupleAlertCard extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;

  const CoupleAlertCard({
    super.key,
    required this.controller,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id;
    final partner =
        currentUserId != null ? controller.couple.value?.partner(currentUserId) : null;
    final partnerName = partner?.fullName;
    final isPartnerAlert =
        partnerName != null && alert.message.contains(partnerName);

    // personal_budget_risk có details → card có cấu trúc riêng
    if (alert.type == 'personal_budget_risk' && alert.details != null) {
      return CoupleAlertStructuredCard(
        controller: controller,
        alert: alert,
        partnerName: partnerName,
        isPartnerAlert: isPartnerAlert,
      );
    }

    // Tất cả loại còn lại (large_transaction, repeated_small_transactions,
    // budget_exceeded, low_wallet_balance, shared_overspend, …)
    return CoupleAlertSimpleCard(
      controller: controller,
      alert: alert,
      partnerName: partnerName,
      isPartnerAlert: isPartnerAlert,
    );
  }
}
