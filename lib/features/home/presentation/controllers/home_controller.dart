import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';

import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';

class HomeController extends GetxController {
  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  final UserController userController = Get.find<UserController>();
  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();
  final WalletController walletController = Get.find<WalletController>();

  final isCategoryExpanded = false.obs;

  void toggleCategoryExpanded() => isCategoryExpanded.toggle();
}
