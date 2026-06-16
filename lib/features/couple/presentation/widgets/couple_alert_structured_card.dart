import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

/// Card có cấu trúc chi tiết dùng cho alert loại [personal_budget_risk].
/// Hiển thị danh mục vượt ngân sách, nguy cơ, và giao dịch bất thường.
class CoupleAlertStructuredCard extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;
  final String? partnerName;
  final bool isPartnerAlert;

  const CoupleAlertStructuredCard({
    super.key,
    required this.controller,
    required this.alert,
    required this.partnerName,
    required this.isPartnerAlert,
  });

  String get _displayMessage {
    String msg = alert.message.split('Các danh mục ')[0];
    msg = msg.replaceAll(RegExp(r'khoảng\s+[0-9\.,\s]+[đ₫VNDvnd]\s*'), '');
    if (isPartnerAlert) {
      msg = '$msg Hãy nhắc nhở đối phương tiết kiệm chi tiêu nhé!';
    }
    return msg.trim();
  }

  @override
  Widget build(BuildContext context) {
    final details = alert.details!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade50.withValues(alpha: 0.7),
            Colors.orange.shade50.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade900.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  alert.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFC53030),
                  ),
                ),
              ),
              _ReminderIconButton(
                controller: controller,
                alert: alert,
                partnerName: partnerName,
                isPartnerAlert: isPartnerAlert,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _displayMessage,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFFEE2E2)),
          const SizedBox(height: 12),

          // Danh mục đã vượt
          if (details.exceededCategories.isNotEmpty) ...[
            _SectionLabel(
              label: 'Danh mục đã vượt ngân sách cá nhân:',
              color: Colors.red.shade700,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: details.exceededCategories
                  .map((cat) => _Pill(
                        label: cat,
                        bgColor: Colors.red.shade100,
                        textColor: Colors.red.shade800,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Danh mục có nguy cơ
          if (details.atRiskCategories.isNotEmpty) ...[
            _SectionLabel(
              label: 'Danh mục có nguy cơ vượt ngân sách:',
              color: Colors.orange.shade800,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: details.atRiskCategories
                  .map((cat) => _Pill(
                        label: cat,
                        bgColor: Colors.orange.shade100,
                        textColor: Colors.orange.shade800,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Giao dịch bất thường
          if (details.anomalies.isNotEmpty) ...[
            _SectionLabel(
              label: 'Các giao dịch lớn bất thường:',
              color: Colors.grey.shade800,
            ),
            const SizedBox(height: 6),
            ...details.anomalies.map((a) => _AnomalyRow(anomaly: a)),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _Pill({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AnomalyRow extends StatelessWidget {
  final CoupleSpendingAlertAnomaly anomaly;

  const _AnomalyRow({required this.anomaly});

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.red.shade100.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anomaly.note.isNotEmpty ? anomaly.note : 'Giao dịch chi tiêu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  anomaly.categoryName,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${AppHelperFunction.formatAmount(anomaly.amount)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              if (anomaly.date.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  _formatDate(anomaly.date),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ReminderIconButton extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;
  final String? partnerName;
  final bool isPartnerAlert;

  const _ReminderIconButton({
    required this.controller,
    required this.alert,
    required this.partnerName,
    required this.isPartnerAlert,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.notifications_active_outlined,
        color: Colors.redAccent,
        size: 20,
      ),
      tooltip: 'Nhắc nhở chi tiêu',
      onPressed: () {
        String msg = alert.message.split('Các danh mục ')[0];
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
