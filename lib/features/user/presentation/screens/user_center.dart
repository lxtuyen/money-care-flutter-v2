import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/payment/presentation/controllers/payment_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/user/presentation/widgets/menu_item.dart';
import 'package:money_care/features/user/presentation/widgets/savings_goals.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key});

  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  final AppController appController = Get.find<AppController>();
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final PaymentController paymentController = Get.find<PaymentController>();

  final TransactionController transactionController =
      Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  /// Initialize: load data only if not already loaded
  /// Reuses cached totalByType from other screens (e.g., Home)
  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();

    if (userId == null) return;

    // Only load if data is not already available (avoid redundant API call)
    if (transactionController.totalByType.value == null) {
      await transactionController.getTotalByType(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!kIsWeb)
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      AppTexts.profileTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final data = transactionController.totalByType.value;
                      final monthlyIncome =
                          userController.userProfile.value?.monthlyIncome ?? 0;

                      if (transactionController.isLoading.value) {
                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (data == null) {
                        return SavingsGoals(currentSaving: 0, targetSaving: 0);
                      }

                      return SavingsGoals(
                        currentSaving:
                            (data.incomeTotal - data.expenseTotal).toDouble(),
                        targetSaving: monthlyIncome.toDouble(),
                      );
                    }),

                    const SizedBox(height: 20),

                    BuildMenuItem(
                      icon: Icons.person_outline,
                      title: AppTexts.profile,
                      onTap: () => Get.toNamed(RoutePath.profile),
                    ),
                    Obx(() {
                      final user = authController.user.value;

                      if (user == null ||
                          user.isVip == true ||
                          paymentController.payment.value == true) {
                        return const SizedBox.shrink();
                      }

                      return BuildMenuItem(
                        icon: Icons.insert_chart_outlined,
                        title: 'Káº¿t ná»‘i Gmail',
                        onTap: () async {
                          await authController.connectGmail();
                        },
                      );
                    }),

                    BuildMenuItem(
                      icon: Icons.category_outlined,
                      title: AppTexts.savingFunds,
                      onTap: () => Get.toNamed(RoutePath.selectSavingFund),
                    ),
                    Obx(() {
                      final user = authController.user.value;
                      if (paymentController.payment.value == true &&
                          user?.isVip == false) {
                        return SizedBox.shrink();
                      }
                      return BuildMenuItem(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'ÄÄƒng kÃ½ VIP',
                        onTap: () {
                          Get.toNamed(RoutePath.payment);
                        },
                      );
                    }),

                    BuildMenuItem(
                      icon: Icons.exit_to_app,
                      title: AppTexts.logout,
                      onTap: () {
                        authController.logout();
                        Get.offAllNamed(RoutePath.loginOption);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
