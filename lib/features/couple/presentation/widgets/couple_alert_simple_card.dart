import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

/// Card đơn giản dùng cho tất cả loại alert không có details cấu trúc:
/// large_transaction, repeated_small_transactions, budget_exceeded,
/// low_wallet_balance, shared_overspend.
class CoupleAlertSimpleCard extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;
  final String? partnerName;
  final bool isPartnerAlert;

  const CoupleAlertSimpleCard({
    super.key,
    required this.controller,
    required this.alert,
    required this.partnerName,
    required this.isPartnerAlert,
  });

  // ── Màu sắc theo loại alert ──────────────────────────────────────────────

  _AlertStyle get _style {
    switch (alert.type) {
      case 'low_wallet_balance':
        return _AlertStyle(
          borderColor: Colors.amber.shade300,
          bgColor: Colors.amber.shade50,
          iconColor: Colors.amber.shade700,
          icon: Icons.account_balance_wallet_outlined,
          severityColor: alert.severity == 'high'
              ? Colors.red.shade700
              : Colors.amber.shade800,
        );
      case 'shared_overspend':
        return _AlertStyle(
          borderColor: Colors.orange.shade300,
          bgColor: Colors.orange.shade50,
          iconColor: Colors.orange.shade700,
          icon: Icons.trending_down_rounded,
          severityColor: alert.severity == 'high'
              ? Colors.red.shade700
              : Colors.orange.shade800,
        );
      case 'budget_exceeded':
        return _AlertStyle(
          borderColor: Colors.red.shade200,
          bgColor: Colors.red.shade50,
          iconColor: Colors.red.shade600,
          icon: Icons.bar_chart_rounded,
          severityColor: Colors.red.shade700,
        );
      case 'repeated_small_transactions':
        return _AlertStyle(
          borderColor: Colors.blue.shade100,
          bgColor: Colors.blue.shade50,
          iconColor: Colors.blue.shade400,
          icon: Icons.repeat_rounded,
          severityColor: Colors.blue.shade700,
        );
      default: // large_transaction và các loại khác
        return _AlertStyle(
          borderColor: Colors.grey.shade200,
          bgColor: Colors.white,
          iconColor: Colors.grey.shade600,
          icon: Icons.warning_amber_rounded,
          severityColor: alert.severity == 'high'
              ? Colors.red.shade600
              : Colors.orange.shade700,
        );
    }
  }

  String get _displayMessage {
    String msg = alert.message;
    // Bỏ số tiền dạng "khoảng X đ" để tránh lặp với amountLabel
    msg = msg.replaceAll(RegExp(r'khoảng\s+[0-9\.,\s]+[đ₫VNDvnd]\s*'), '');
    if (isPartnerAlert) {
      msg = '$msg Hãy nhắc nhở đối phương tiết kiệm chi tiêu nhé!';
    }
    return msg.trim();
  }

  String get _amountLabel {
    switch (alert.type) {
      case 'low_wallet_balance':
        return 'Số dư: ${AppHelperFunction.formatAmount(alert.amount)}';
      case 'shared_overspend':
        return 'Chi vượt: ${AppHelperFunction.formatAmount(alert.amount)}';
      default:
        return AppHelperFunction.formatAmount(alert.amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: style.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícôn loại alert
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 10),
            child: Icon(style.icon, color: style.iconColor, size: 22),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + nút nhắc nhở
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: style.severityColor,
                        ),
                      ),
                    ),
                    _ReminderButton(
                      controller: controller,
                      alert: alert,
                      partnerName: partnerName,
                      isPartnerAlert: isPartnerAlert,
                      iconColor: style.iconColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _displayMessage,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  _amountLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
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

// ── Style data class ──────────────────────────────────────────────────────────

class _AlertStyle {
  final Color borderColor;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Color severityColor;

  const _AlertStyle({
    required this.borderColor,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.severityColor,
  });
}

// ── Nút nhắc nhở dùng chung ───────────────────────────────────────────────────

class _ReminderButton extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;
  final String? partnerName;
  final bool isPartnerAlert;
  final Color iconColor;

  const _ReminderButton({
    required this.controller,
    required this.alert,
    required this.partnerName,
    required this.isPartnerAlert,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.notifications_active_outlined, color: iconColor, size: 20),
      tooltip: 'Nhắc nhở chi tiêu',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onPressed: () {
        String msg = alert.message;
        msg = msg.replaceAll(
            RegExp(r'khoảng\s+[0-9\.,\s]+[đ₫VNDvnd]\s*'), '');
        if (partnerName != null && isPartnerAlert) {
          msg = msg.replaceAll(partnerName!, 'bạn');
          msg = '$msg Hãy tiết kiệm chi tiêu nhé!';
        }
        controller.sendSpendingAlertReminder(
          alertId: alert.id,
          title: alert.title,
          message: msg.trim(),
          amount: alert.amount,
        );
      },
    );
  }
}
