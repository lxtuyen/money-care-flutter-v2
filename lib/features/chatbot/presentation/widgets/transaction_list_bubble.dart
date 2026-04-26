import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionListBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const TransactionListBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final List transactionMaps = metadata['transactions'] as List? ?? [];
    final transactions = transactionMaps
        .map((m) => TransactionEntity.fromMap(m as Map<String, dynamic>))
        .toList();
    final int total = metadata['total'] as int? ?? transactions.length;
    final Map<String, dynamic> query =
        metadata['query'] as Map<String, dynamic>? ?? {};

    final String type = query['type'] as String? ?? 'all';
    final String? startDate = query['startDate'] as String?;
    final String? endDate = query['endDate'] as String?;



    String periodLabel = _buildPeriodLabel(startDate, endDate);
    String typeLabel = _buildTypeLabel(type);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$typeLabel${periodLabel.isNotEmpty ? ' · $periodLabel' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$total giao dịch',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (transactions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Không có giao dịch nào trong khoảng thời gian này.',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final bool isIncome = transaction.type == 'income';

                  String formattedDate = '';
                  if (transaction.transactionDate != null) {
                    formattedDate = AppHelperFunction.formatDayMonth(
                      transaction.transactionDate!.toLocal(),
                    );
                  }

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          Get.find<ChatController>().onTransactionTap(transactionMaps[index] as Map<String, dynamic>),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    (isIncome
                                            ? const Color(0xFF43A047)
                                            : const Color(0xFFE53935))
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  transaction.category?.icon ?? '💰',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.category?.name ?? 'Chưa phân loại',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (transaction.note?.isNotEmpty ?? false)
                                    Text(
                                      transaction.note!,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            // Amount + date
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isIncome ? '+' : '-'}${AppHelperFunction.formatAmount(transaction.amount.toDouble())}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isIncome
                                        ? const Color(0xFF43A047)
                                        : const Color(0xFFE53935),
                                  ),
                                ),
                                if (formattedDate.isNotEmpty)
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Summary footer
            if (transactions.isNotEmpty)
              _buildSummaryFooter(transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryFooter(List<TransactionEntity> transactions) {
    double totalIncome = 0;
    double totalExpense = 0;
    for (final t in transactions) {
      final amount = t.amount.toDouble();
      if (t.type == 'income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    }

    final hasIncome = totalIncome > 0;
    final hasExpense = totalExpense > 0;
    if (!hasIncome && !hasExpense) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (hasIncome)
            Flexible(
              child: _SummaryChip(
                label: 'Thu',
                amount: AppHelperFunction.formatAmount(totalIncome),
                color: const Color(0xFF43A047),
                icon: Icons.arrow_downward_rounded,
              ),
            ),
          if (hasIncome && hasExpense)
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          if (hasExpense)
            Flexible(
              child: _SummaryChip(
                label: 'Chi',
                amount: AppHelperFunction.formatAmount(totalExpense),
                color: const Color(0xFFE53935),
                icon: Icons.arrow_upward_rounded,
              ),
            ),
        ],
      ),
    );
  }

  String _buildPeriodLabel(String? startDate, String? endDate) {
    if (startDate == null && endDate == null) return '';
    try {

      final start = startDate != null ? DateTime.parse(startDate) : null;
      final end = endDate != null ? DateTime.parse(endDate) : null;
      if (start != null && end != null) {
        final startStr = AppHelperFunction.formatDayMonth(start.toLocal());
        final endStr = AppHelperFunction.formatDayMonth(end.toLocal());
        if (startStr == endStr) return startStr;
        return '$startStr - $endStr';
      }
      if (start != null) return 'từ ${AppHelperFunction.formatDayMonth(start.toLocal())}';
      if (end != null) return 'đến ${AppHelperFunction.formatDayMonth(end.toLocal())}';
    } catch (_) {}
    return '';
  }

  String _buildTypeLabel(String type) {
    switch (type) {
      case 'income':
        return 'Lịch sử thu nhập';
      case 'expense':
        return 'Lịch sử chi tiêu';
      default:
        return 'Lịch sử giao dịch';
    }
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '$label: $amount',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
