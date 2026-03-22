import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/saving_fund/presentation/widgets/saving_fund_item_card.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';

class SelectSavingFundScreen extends StatefulWidget {
  const SelectSavingFundScreen({super.key});

  @override
  State<SelectSavingFundScreen> createState() => _SelectSavingFundScreenState();
}

class _SelectSavingFundScreenState extends State<SelectSavingFundScreen> {
  final SavingFundController controller = Get.find<SavingFundController>();
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    controller.loadUserAndFunds();
  }

  Future<void> _handleConfirm() async {
    if (controller.savingFunds.isEmpty) return;

    final selectedFund =
        controller.savingFunds[controller.selectedFundIndex.value];

    try {
      await controller.selectSavingFund(
        controller.currentUserId.value ?? 0,
        selectedFund.id,
      );

      if (userController.userProfile.value?.monthlyIncome == null) {
        Get.toNamed(RoutePath.onboardingIncome);
      } else {
        Get.toNamed(RoutePath.main);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu quỹ tiết kiệm');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Lựa chọn quỹ tiết kiệm?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingFunds.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.savingFunds.isEmpty) {
                      return const Center(
                        child: Text("Chưa có quỹ tiết kiệm nào"),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.savingFunds.length,
                      itemBuilder: (context, index) {
                        final fund = controller.savingFunds[index];

                        return Obx(() {
                          return GestureDetector(
                            onTap:
                                () => controller.updateSelectedFundIndex(index),
                            child: SavingFundItemCard(
                              fund: fund,
                              isSelected:
                                  controller.selectedFundIndex.value == index,
                              onTap:
                                  () =>
                                      controller.updateSelectedFundIndex(index),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(RoutePath.createSavingFund);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF0F5),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Tự tạo quỹ tiết kiệm'),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  final isLoading = controller.isLoadingCurrent.value;
                  return PrimaryButton(
                    label: 'Xác nhận',
                    onPressed: _handleConfirm,
                    isLoading: isLoading,
                  );
                }),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
