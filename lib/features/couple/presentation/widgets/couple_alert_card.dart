import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

class CoupleAlertCard extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;

  const CoupleAlertCard({super.key, required this.controller, required this.alert});

  @override
  Widget build(BuildContext context) {
    if (alert.type == 'personal_budget_risk' && alert.details != null) {
      return _buildStructuredAlertCard(context);
    }

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
              Expanded(
                child: Text(
                  alert.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildStructuredAlertCard(BuildContext context) {
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
          Row(
            children: [
              const Icon(
                Icons.report_gmailerrorred_rounded,
                color: Colors.redAccent,
                size: 24,
              ),
              const SizedBox(width: 10),
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
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.message.split('Các danh mục ')[0],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFFEE2E2)),
          const SizedBox(height: 12),
          if (details.exceededCategories.isNotEmpty) ...[
            _buildSectionLabel('Danh mục đã vượt ngân sách cá nhân:', Colors.red.shade700),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: details.exceededCategories
                  .map((cat) => _buildPill(cat, Colors.red.shade100, Colors.red.shade800))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (details.atRiskCategories.isNotEmpty) ...[
            _buildSectionLabel('Danh mục có nguy cơ vượt ngân sách:', Colors.orange.shade800),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: details.atRiskCategories
                  .map((cat) => _buildPill(cat, Colors.orange.shade100, Colors.orange.shade800))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (details.anomalies.isNotEmpty) ...[
            _buildSectionLabel('Các giao dịch lớn bất thường:', Colors.grey.shade800),
            const SizedBox(height: 6),
            Column(
              children: details.anomalies.map((anom) => _buildAnomalyRow(anom)).toList(),
            ),
            const SizedBox(height: 12),
          ],
          _buildImpactBox(details),

        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color color) {
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

  Widget _buildPill(String label, Color bgColor, Color textColor) {
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

  Widget _buildAnomalyRow(CoupleSpendingAlertAnomaly anomaly) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade100.withValues(alpha: 0.5)),
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
                  _formatIsoDate(anomaly.date),
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

  String _formatIsoDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  Widget _buildImpactBox(CoupleSpendingAlertDetails details) {
    final hasImpact = details.impactsGoals;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasImpact
            ? Colors.red.shade50.withValues(alpha: 0.6)
            : Colors.blue.shade50.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasImpact ? Colors.red.shade200 : Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasImpact ? Icons.error : Icons.info_outline,
                color: hasImpact ? Colors.red.shade700 : Colors.blue.shade700,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Tác động đến tiết kiệm',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: hasImpact ? Colors.red.shade800 : Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Số tiền tiết kiệm dự kiến của tháng = ${AppHelperFunction.formatAmount(details.projectedSaving)}.',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasImpact
                ? 'Không thể đóng góp cho mục tiêu tiết kiệm chung của cặp đôi trong tháng này.'
                : 'Hiện tại chưa ảnh hưởng trực tiếp đến mục tiêu chung nhưng cần tối ưu hóa để đảm bảo kế hoạch.',
            style: TextStyle(
              fontSize: 12,
              color: hasImpact ? Colors.red.shade900 : Colors.grey.shade700,
              fontWeight: hasImpact ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          if (hasImpact && details.savingGoalImpacts.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...details.savingGoalImpacts.map((g) => Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          g,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade900,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
