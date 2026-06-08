import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';

class AnomaliesPanel extends StatelessWidget {
  final List<AnomalyModel> anomalies;

  const AnomaliesPanel({super.key, required this.anomalies});

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    final appController = Get.find<AppController>();

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.report_problem_outlined,
                color: AppColors.error,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Giao dịch chi tiêu bất thường',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            // Reactive khi transaction thay đổi (vd: xóa/sửa)
            final _ = transactionController.transactionChangedCount.value;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: anomalies.length,
              itemBuilder: (context, index) {
                final anomaly = anomalies[index];

                final tx =
                    transactionController.allTransactions
                        .firstWhereOrNull((t) => t.id == anomaly.transactionId)
                    ?? anomaly.toTransactionEntity();

                return TransactionItem(
                  item: tx,
                  isShowDate: true,
                  isShowDivider: index < anomalies.length - 1,
                  onTap: () {
                    final userId = appController.userId.value ?? 0;
                    TransactionDetail.show(
                      context,
                      item: tx,
                      userId: userId,
                      isExpense: anomaly.type == 'expense',
                    );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
