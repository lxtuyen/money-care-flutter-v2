import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/core/constants/colors.dart';

class CoupleSpendingAlertsSection extends StatelessWidget {
  final CoupleController controller;

  const CoupleSpendingAlertsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final report = controller.coupleReport.value;
      if (report == null) return const SizedBox.shrink();

      // Chỉ hiển thị các cảnh báo giao dịch bất thường
      const spendingAlertTypes = {
        'large_transaction',
        'repeated_small_transactions',
      };
      final alerts = report.alerts
          .where((a) => spendingAlertTypes.contains(a.type))
          .toList();

      // Lấy transactionId từ alerts và match với sharedTransactions
      final alertTxIds = alerts
          .where((a) => a.transactionId != null)
          .map((a) => a.transactionId!)
          .toSet();

      final flaggedTransactions = controller.sharedTransactions
          .where((tx) => alertTxIds.contains(tx.id))
          .toList();

      final currentUserId =
          Get.find<AuthController>().user.value?.id ?? 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          AppSectionHeading(
            title: 'Giao Dịch Bất Thường',
            onPressed: null,
            showActionButton: false,
          ),
          const SizedBox(height: 8),
          if (flaggedTransactions.isEmpty)
            const AppEmptyState(
              message: 'Không phát hiện giao dịch bất thường.',
            )
          else
            ...flaggedTransactions.map(
              (tx) {
                // Tìm alert tương ứng để lấy thêm thông tin
                final alert = alerts.firstWhereOrNull(
                  (a) => a.transactionId == tx.id,
                );

                return TransactionItem(
                  item: tx,
                  currentUserId: currentUserId,
                  color: AppColors.expense,
                  subtitle: alert?.title ?? tx.category?.name,
                  onTap: () {},
                );
              },
            ),
        ],
      );
    });
  }
}
