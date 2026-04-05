import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/features/fund/presentation/controllers/fund_controller.dart';
import 'package:money_care/features/fund/presentation/screens/expired_funds_screen.dart';
import 'package:money_care/features/fund/presentation/widgets/fund_item_card.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';

class SelectFundScreen extends StatefulWidget {
  const SelectFundScreen({super.key});

  @override
  State<SelectFundScreen> createState() => _SelectFundScreenState();
}

class _SelectFundScreenState extends State<SelectFundScreen> {
  final FundController controller = Get.find<FundController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeSelectFund();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: Text('Lựa chọn quỹ tiết kiệm'),
        showBackArrow: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingFunds.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.funds.isEmpty) {
                      return const Center(
                        child: Text('Chưa có quỹ tiết kiệm nào'),
                      );
                    }

                    final spendingFunds = controller.funds.where((f) => f.type == FundType.spending).toList();
                    final savingGoalFunds = controller.funds.where((f) => f.type == FundType.savingGoal).toList();

                    return ListView(
                      children: [
                        if (spendingFunds.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Quỹ chi tiêu (Wallet)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                          ...spendingFunds.map((fund) {
                            final index = controller.funds.indexOf(fund);
                            return Obx(() {
                              return GestureDetector(
                                onTap: () => controller.updateSelectedFundIndex(index),
                                child: FundItemCard(
                                  fund: fund,
                                  isSelected: controller.selectedFundIndex.value == index,
                                  onTap: () => controller.updateSelectedFundIndex(index),
                                  onDelete: () => _confirmDelete(context, fund),
                                  onUpdate: () => _handleUpdate(fund),
                                ),
                              );
                            });
                          }),
                        ],
                        if (savingGoalFunds.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Mục tiêu tiết kiệm (Piggy Bank)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondaryOrange),
                            ),
                          ),
                          ...savingGoalFunds.map((fund) {
                            final index = controller.funds.indexOf(fund);
                            return Obx(() {
                              return GestureDetector(
                                onTap: () => controller.updateSelectedFundIndex(index),
                                child: FundItemCard(
                                  fund: fund,
                                  isSelected: controller.selectedFundIndex.value == index,
                                  onTap: () => controller.updateSelectedFundIndex(index),
                                  onDelete: () => _confirmDelete(context, fund),
                                  onUpdate: () => _handleUpdate(fund),
                                ),
                              );
                            });
                          }),
                        ],
                      ],
                    );
                  }),
                ),
                ElevatedButton.icon(
                  onPressed: controller.goToCreateFund,
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
                const SizedBox(height: 8),
                Obx(() {
                  final expiredCount = controller.funds
                      .where((f) =>
                          f.endDate != null &&
                          f.endDate!.isBefore(DateTime.now()))
                      .length;
                  if (expiredCount == 0) return const SizedBox.shrink();
                  return ElevatedButton.icon(
                    onPressed: () => Get.to(() => const ExpiredFundsScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryOrange.withOpacity(0.1),
                      foregroundColor: AppColors.secondaryOrange,
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.secondaryOrange.withOpacity(0.4),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.timer_off_rounded),
                    label: Text('Quỹ hết hạn ($expiredCount)'),
                  );
                }),
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

  void _confirmDelete(BuildContext context, FundEntity fund) {
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

  void _handleUpdate(FundEntity fund) {
    Get.toNamed(RoutePath.createFund, arguments: fund);
  }
}


