import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AnalysisBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const AnalysisBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final summary = metadata['summary'] ?? '';
    final budgetPlan = metadata['budget_plan'] as List? ?? [];
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.chart_2_copy, size: 20, color: Colors.blueAccent),
              ),
              const SizedBox(width: 12),
              const Text(
                'Phân tích thông minh',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const Divider(height: 32),
          ...budgetPlan.map((group) => _buildGroup(group, currencyFormat)),
          const SizedBox(height: 8),
          _buildDecorativeFooter(),
        ],
      ),
    );
  }

  Widget _buildGroup(dynamic group, NumberFormat format) {
    final String groupName = group['group_name'] ?? 'Khác';
    final List items = group['items'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => _buildItem(item, format)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildItem(dynamic item, NumberFormat format) {
    final String name = item['name'] ?? '';
    final double amount = (item['amount'] as num?)?.toDouble() ?? 0;
    final String description = item['description'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '$name: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: format.format(amount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      TextSpan(text: ' ($description)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Iconsax.info_circle_copy, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Gợi ý này dựa trên thói quen chi tiêu của bạn. Hãy điều chỉnh cụ thể trong mục Ngân sách.',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
