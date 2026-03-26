import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/saving_fund/presentation/widgets/saving_fund_item_card.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';

class SelectSavingFundScreen extends StatefulWidget {
  const SelectSavingFundScreen({super.key});

  @override
  State<SelectSavingFundScreen> createState() => _SelectSavingFundScreenState();
}

class _SelectSavingFundScreenState extends State<SelectSavingFundScreen> {
  final SavingFundController controller = Get.find<SavingFundController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeSelectSavingFund();
    });
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
                  'Lựa chọn quỹ tiết kiệm',
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
                        child: Text('Chưa có quỹ tiết kiệm nào'),
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
                                  () => controller.updateSelectedFundIndex(index),
                              onDelete: () => _confirmDelete(context, fund),
                              onUpdate: () => _handleUpdate(fund),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
                ElevatedButton.icon(
                  onPressed: controller.goToCreateSavingFund,
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
                    onPressed: controller.confirmSelectedFund,
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

  void _confirmDelete(BuildContext context, SavingFundEntity fund) {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa quỹ "${fund.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              controller.deleteFund(fund.id);
              Get.back();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleUpdate(SavingFundEntity fund) {
    Get.toNamed(RoutePath.createSavingFund, arguments: fund);
  }
}
