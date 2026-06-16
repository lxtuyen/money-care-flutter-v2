import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

/// Card đơn giản dùng cho tất cả loại alert không có details cấu trúc:
/// large_transaction, repeated_small_transactions, budget_exceeded,
/// low_wallet_balance, shared_overspend.
class CoupleAlertSimpleCard extends StatefulWidget {
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

  @override
  State<CoupleAlertSimpleCard> createState() => _CoupleAlertSimpleCardState();
}

class _CoupleAlertSimpleCardState extends State<CoupleAlertSimpleCard> {
  late bool isCollapsed;

  @override
  void initState() {
    super.initState();
    isCollapsed = widget.alert.isRead;
  }

  @override
  void didUpdateWidget(CoupleAlertSimpleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.alert.isRead != widget.alert.isRead) {
      isCollapsed = widget.alert.isRead;
    }
  }

  // ── Màu sắc theo loại alert ──────────────────────────────────────────────

  _AlertStyle get _style {
    switch (widget.alert.type) {
      case 'low_wallet_balance':
        return _AlertStyle(
          borderColor: Colors.amber.shade300,
          bgColor: Colors.amber.shade50,
          iconColor: Colors.amber.shade700,
          icon: Icons.account_balance_wallet_outlined,
          severityColor: widget.alert.severity == 'high'
              ? Colors.red.shade700
              : Colors.amber.shade800,
        );
      case 'shared_overspend':
        return _AlertStyle(
          borderColor: Colors.orange.shade300,
          bgColor: Colors.orange.shade50,
          iconColor: Colors.orange.shade700,
          icon: Icons.trending_down_rounded,
          severityColor: widget.alert.severity == 'high'
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
          severityColor: widget.alert.severity == 'high'
              ? Colors.red.shade600
              : Colors.orange.shade700,
        );
    }
  }

  String get _displayMessage {
    String msg = widget.alert.message;
    // Bỏ số tiền dạng "khoảng X đ" để tránh lặp với amountLabel
    msg = msg.replaceAll(RegExp(r'khoảng\s+[0-9\.,\s]+[đ₫VNDvnd]\s*'), '');
    if (widget.isPartnerAlert) {
      msg = '$msg Hãy nhắc nhở đối phương tiết kiệm chi tiêu nhé!';
    }
    return msg.trim();
  }

  String get _amountLabel {
    switch (widget.alert.type) {
      case 'low_wallet_balance':
        return 'Số dư: ${AppHelperFunction.formatAmount(widget.alert.amount)}';
      case 'shared_overspend':
        return 'Chi vượt: ${AppHelperFunction.formatAmount(widget.alert.amount)}';
      default:
        return AppHelperFunction.formatAmount(widget.alert.amount);
    }
  }

  void _confirmDelete(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xóa cảnh báo'),
        content: const Text('Bạn có chắc chắn muốn xóa cảnh báo chi tiêu này?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              widget.controller.deleteAlert(widget.alert.id);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsed(BuildContext context) {
    final style = _style;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: style.bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: style.borderColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(style.icon, color: style.iconColor.withValues(alpha: 0.6), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.alert.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: style.severityColor.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Đã đọc',
              style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.expand_more, color: style.iconColor.withValues(alpha: 0.7), size: 18),
            tooltip: 'Mở rộng',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () {
              setState(() {
                isCollapsed = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
            tooltip: 'Xóa cảnh báo',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return _buildCollapsed(context);
    }

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
                // Title + các nút hành động
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.alert.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: style.severityColor,
                        ),
                      ),
                    ),
                    _ReminderButton(
                      controller: widget.controller,
                      alert: widget.alert,
                      partnerName: widget.partnerName,
                      isPartnerAlert: widget.isPartnerAlert,
                      iconColor: style.iconColor,
                    ),
                    if (!widget.alert.isRead)
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                        tooltip: 'Đánh dấu đã đọc',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        onPressed: () => widget.controller.markAlertRead(widget.alert.id),
                      )
                    else
                      IconButton(
                        icon: Icon(Icons.expand_less, color: style.iconColor, size: 20),
                        tooltip: 'Thu gọn',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        onPressed: () {
                          setState(() {
                            isCollapsed = true;
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      tooltip: 'Xóa cảnh báo',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      onPressed: () => _confirmDelete(context),
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
