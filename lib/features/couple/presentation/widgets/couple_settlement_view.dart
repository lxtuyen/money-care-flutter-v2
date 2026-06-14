import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';

class CoupleSettlementView extends StatelessWidget {
  final CoupleController controller;

  const CoupleSettlementView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id ?? 0;

    return Obx(() {
      if (controller.isSettlementLoading.value &&
          controller.settlementSummary.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final summary = controller.settlementSummary.value;
      if (summary == null) {
        return const Center(child: Text('Không tải được thông tin quyết toán'));
      }

      final whoOwes = summary.whoOwesWhom;
      final hasDebt = whoOwes != null && whoOwes.amount > 0;
      final amIDebtor = hasDebt && whoOwes.debtorId == currentUserId;

      return RefreshIndicator(
        onRefresh: () => controller.fetchSettlementSummary(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Net Balance Card
              Card(
                elevation: 0,
                color: hasDebt
                    ? (amIDebtor
                          ? Colors.red.withValues(alpha: 0.03)
                          : Colors.green.withValues(alpha: 0.03))
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: hasDebt
                        ? (amIDebtor
                              ? Colors.red.withValues(alpha: 0.4)
                              : Colors.green.withValues(alpha: 0.4))
                        : Colors.grey[200]!,
                    width: hasDebt ? 1 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'TRẠNG THÁI DƯ NỢ HIỆN TẠI',
                        style: theme.textTheme.bodySmall?.copyWith(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!hasDebt) ...[
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.green,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Hai bạn đã quyết toán xong!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Không có giao dịch chia tiền nào cần thanh toán.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          amIDebtor
                              ? Icons.money_off_rounded
                              : Icons.monetization_on_rounded,
                          color: amIDebtor ? Colors.red : Colors.green,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          amIDebtor
                              ? 'Bạn đang nợ ${whoOwes.creditorName}'
                              : '${whoOwes.debtorName} đang nợ bạn',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: amIDebtor
                                ? Colors.red[700]
                                : Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppHelperFunction.formatAmount(whoOwes.amount),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: amIDebtor ? Colors.red : Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: amIDebtor
                                      ? Colors.red
                                      : Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                icon: const Icon(Icons.handshake_rounded),
                                label: const Text(
                                  'Quyết Toán Tất Cả',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () => _confirmSettleUp(context),
                              ),
                            ),
                            if (!amIDebtor) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                                  foregroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                ),
                                icon: const Icon(Icons.notifications_active_outlined),
                                tooltip: 'Nhắc quyết toán',
                                onPressed: () {
                                  controller.sendSettlementReminder(
                                    amount: whoOwes.amount,
                                    debtorName: whoOwes.debtorName,
                                    creditorName: whoOwes.creditorName,
                                    debtorId: whoOwes.debtorId,
                                    creditorId: whoOwes.creditorId,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Unsettled Transactions List Header
              Text(
                'KHOẢN CHƯA QUYẾT TOÁN (${summary.unsettledTransactions.length})',
                style: theme.textTheme.bodySmall?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),

              if (summary.unsettledTransactions.isEmpty)
                const AppEmptyState(
                  message: 'Tất cả giao dịch chia tiền đã được quyết toán!',
                )
              else
                Column(
                  children: summary.unsettledTransactions.map((tx) {
                    return _UnsettledTransactionCard(
                      transaction: tx,
                      currentUserId: currentUserId,
                      primaryColor: primaryColor,
                      onTap: () {
                        AppConfirmDialog.show(
                          title: 'Quyết toán khoản chi?',
                          message: 'Bạn có chắc chắn muốn quyết toán giao dịch "${tx.note != null && tx.note!.isNotEmpty ? tx.note : (tx.category?.name ?? 'Giao dịch chung')}" này không? Giao dịch sẽ được đánh dấu là đã thanh toán.',
                          confirmText: 'Đồng ý',
                          cancelText: 'Hủy',
                          type: ConfirmDialogType.info,
                          onConfirm: () {
                            if (tx.id != null) {
                              controller.settleUpSingle(tx.id!);
                            }
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );
    });
  }

  void _confirmSettleUp(BuildContext context) {
    AppConfirmDialog.show(
      title: 'Xác nhận Quyết Toán',
      message: 'Hành động này sẽ ghi nhận là hai bạn đã thanh toán xong cho nhau và đánh dấu tất cả giao dịch chia tiền hiện tại là đã quyết toán. Bạn có chắc chắn?',
      confirmText: 'Đồng ý',
      cancelText: 'Hủy',
      type: ConfirmDialogType.info,
      onConfirm: () => controller.settleUpAll(),
    );
  }
}

class _UnsettledTransactionCard extends StatelessWidget {
  final TransactionEntity transaction;
  final int currentUserId;
  final Color primaryColor;
  final VoidCallback? onTap;

  const _UnsettledTransactionCard({
    required this.transaction,
    required this.currentUserId,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tx = transaction;
    final isPayerMe = tx.payerId == currentUserId;
    final splitMe = tx.splits?.firstWhere(
      (s) => s.userId == currentUserId,
      orElse: () => TransactionSplitEntity(
        userId: 0,
        userName: '',
        amount: 0,
      ),
    );
    final splitPartner = tx.splits?.firstWhere(
      (s) => s.userId != currentUserId,
      orElse: () => TransactionSplitEntity(
        userId: 0,
        userName: '',
        amount: 0,
      ),
    );

    String splitMethodText = '';
    if (tx.splitMethod == 'equal') {
      splitMethodText = 'Chia đều';
    } else if (tx.splitMethod == 'percentage') {
      splitMethodText = 'Chia %';
    } else if (tx.splitMethod == 'fixed') {
      splitMethodText = 'Chia cố định';
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tx.category?.icon ?? '💰',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.note != null && tx.note!.isNotEmpty
                                ? tx.note!
                                : (tx.category?.name ?? 'Giao dịch chung'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tx.transactionDate != null
                                ? DateFormat('dd/MM/yyyy HH:mm').format(tx.transactionDate!)
                                : '',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppHelperFunction.formatAmount(tx.amount.toDouble()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          splitMethodText,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Người trả: ${isPayerMe ? 'Bạn' : (tx.payerName ?? 'Thành viên')}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Bạn chịu: ${AppHelperFunction.formatAmount(splitMe?.amount ?? 0)}'
                        '${splitMe?.percent != null ? ' (${splitMe!.percent!.toStringAsFixed(0)}%)' : ''}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Partner chịu: ${AppHelperFunction.formatAmount(splitPartner?.amount ?? 0)}'
                        '${splitPartner?.percent != null ? ' (${splitPartner!.percent!.toStringAsFixed(0)}%)' : ''}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
