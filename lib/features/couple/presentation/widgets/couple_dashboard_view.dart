import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/features/wallet/presentation/widgets/wallet_card.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_time_navigator.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_spending_alerts_section.dart';
import 'package:money_care/core/constants/colors.dart';

class CoupleDashboardView extends StatelessWidget {
  final CoupleController controller;

  const CoupleDashboardView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Month Selector Header
          Obx(
            () => StatisticsTimeNavigator(
              focusedMonth: controller.selectedMonth.value,
              onPrevious: () {
                final current = controller.selectedMonth.value;
                controller.changeMonth(
                  DateTime(current.year, current.month - 1),
                );
              },
              onNext: () {
                final current = controller.selectedMonth.value;
                controller.changeMonth(
                  DateTime(current.year, current.month + 1),
                );
              },
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedMonth.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDatePickerMode: DatePickerMode.year,
                );
                if (picked != null) {
                  controller.changeMonth(picked);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          // Total Balance Card
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.primary),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Tổng Số Dư Ví Chung',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      AppHelperFunction.formatAmount(
                        controller.totalBalance.value,
                      ),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Income & Expense Summary Widgets
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.green.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.green, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.arrow_downward_rounded,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Thu nhập chung',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            AppHelperFunction.formatAmount(
                              controller.totalIncome.value,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.red.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.red, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Chi tiêu chung',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            AppHelperFunction.formatAmount(
                              controller.totalExpense.value,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Shared Wallets Header
          AppSectionHeading(
            title: 'Ví Chung',
            buttonTitle: 'Thêm mới',
            onPressed: () {
              final nextNumber = controller.sharedWallets.length + 1;
              final walletName = 'Ví chung $nextNumber';
              controller.addSharedWallet(walletName, 0.0);
            },
          ),
          const SizedBox(height: 8),

          // Shared Wallets List
          Obx(() {
            if (controller.sharedWallets.isEmpty) {
              return const AppEmptyState(
                message: 'Chưa có ví chung nào. Hãy tạo một ví mới!',
              );
            }
            return Column(
              children: controller.sharedWallets.map((wallet) {
                return WalletCard(wallet: wallet, marginBottom: 12);
              }).toList(),
            );
          }),

          CoupleSpendingAlertsSection(controller: controller),
        ],
      ),
    );
  }
}
