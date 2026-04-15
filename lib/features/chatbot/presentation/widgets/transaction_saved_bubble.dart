import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';

class TransactionSavedBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const TransactionSavedBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final double amount = (metadata['amount'] as num?)?.toDouble() ?? 0;
    final String category = metadata['category'] ?? 'Chi tiêu';
    final String categoryIcon = metadata['categoryIcon'] ?? '💰';
    final String note = metadata['note'] ?? '';
    final String? dateStr = metadata['date'] as String?;

    final String type = metadata['type'] ?? 'expense';
    final bool isIncome = type == 'income';

    final currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    if (dateStr != null) {
      try {
        formattedDate =
            DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStr));
      } catch (_) {}
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.find<ChatController>().onTransactionTap(metadata),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isIncome
                          ? [const Color(0xFF00b09b), const Color(0xFF96c93d)]
                          : [const Color(0xFF11998e), const Color(0xFF38ef7d)],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        isIncome
                            ? 'Đã ghi nhận thu nhập'
                            : 'Đã ghi nhận chi tiêu',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon category
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: (isIncome
                                  ? const Color(0xFF00b09b)
                                  : const Color(0xFF11998e))
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            categoryIcon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            if (note.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                note,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Amount
                      Text(
                        '${isIncome ? '+' : '-'} ${currencyFormat.format(amount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isIncome
                              ? const Color(0xFF43A047)
                              : const Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
