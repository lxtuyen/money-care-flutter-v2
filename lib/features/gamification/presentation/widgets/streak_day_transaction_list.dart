import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/gamification/presentation/controllers/streak_calendar_controller.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';

class StreakDayTransactionList extends StatelessWidget {
  final StreakCalendarController controller;
  final AppController appController;

  const StreakDayTransactionList({
    super.key,
    required this.controller,
    required this.appController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedDay.value == 0
                      ? 'streak.selectDayDesc'.tr
                      : 'streak.transactionOnDay'.trParams({
                          'day': '${controller.selectedDay.value}',
                        }),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1,
                  ),
                ),
                if (controller.selectedDayTransactions.isNotEmpty)
                  Text(
                    'streak.transactionCount'.trParams({
                      'count': '${controller.selectedDayTransactions.length}',
                    }),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text3,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.selectedDayTransactions.isEmpty) {
              return AppEmptyState(message: 'streak.noTransactionOnDay'.tr);
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.selectedDayTransactions.length,
                itemBuilder: (context, index) {
                  final tx = controller.selectedDayTransactions[index];
                  return TransactionItem(
                    item: tx,
                    isShowDate: false,
                    isShowDivider:
                        index < controller.selectedDayTransactions.length - 1,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => TransactionDetail(
                          item: tx,
                          isExpense: tx.type == 'expense',
                          userId: appController.userId.value ?? 0,
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
