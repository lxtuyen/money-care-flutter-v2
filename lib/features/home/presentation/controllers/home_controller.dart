import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';

class HomeController extends GetxController {
  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController = Get.find<TransactionController>();
  final StatisticsController statisticsController = Get.find<StatisticsController>();
  final FinanceModeController financeModeController = Get.find<FinanceModeController>();
  final UserController userController = Get.find<UserController>();
  final SavingGoalController savingGoalController = Get.find<SavingGoalController>();

  final now = DateTime.now();
  late DateTime startDate = now.subtract(const Duration(days: 6));
  late DateTime endDate = now;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    checkModeSuggestion();
  }

  void checkModeSuggestion() async {
    final utilization = statisticsController.utilizationPercentage;
    if (utilization >= 0.8) {
      final suggestedMode = await financeModeController.checkAndSuggestMode(utilization);
      if (suggestedMode != null) {
        showSuggestionDialog(suggestedMode);
      }
    }
  }

  void showSuggestionDialog(FinanceMode suggestedMode) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.borderPrimary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Gợi ý chế độ tài chính',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
              'Bạn đã tiêu quá ${(statisticsController.utilizationPercentage * 100).toInt()}% ngân sách tháng này. Bạn có muốn chuyển sang chế độ Sinh tồn để tối ưu hóa chi tiêu?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.text4),
            )),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      financeModeController.declineSuggestion();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Bỏ qua'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      financeModeController.switchMode(suggestedMode);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Bật Sinh tồn',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}


