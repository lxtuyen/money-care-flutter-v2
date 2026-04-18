import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/appbar/appbar.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/saving_goal_item_card.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';

class SelectSavingGoalScreen extends StatefulWidget {
  const SelectSavingGoalScreen({super.key});

  @override
  State<SelectSavingGoalScreen> createState() => _SelectSavingGoalScreenState();
}

class _SelectSavingGoalScreenState extends State<SelectSavingGoalScreen> {
  final SavingGoalController controller = Get.find<SavingGoalController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeSelectGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarCustom(
        title: Text('Chọn mục tiêu đang thực hiện'),
        showBackArrow: true,
      ),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingGoals.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.goals.isEmpty) {
                      return const AppEmptyState(
                        message: 'Bạn chưa thiết lập mục tiêu nào.',
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.goals.length,
                      itemBuilder: (context, index) {
                        final goal = controller.goals[index];
                        return Obx(() {
                          final isSelected = controller.selectedGoalIndex.value == index;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SavingGoalItemCard(
                              fund: goal,
                              isSelected: isSelected,
                              onTap: () => controller.updateSelectedGoalIndex(index),
                              onDelete: () => _confirmDelete(context, goal),
                              onUpdate: () => _handleUpdate(goal),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: controller.goToCreateGoal,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Thiết lập mục tiêu mới'),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final isLoading = controller.isLoadingCurrent.value;
                  return PrimaryButton(
                    label: 'Sử dụng mục tiêu này',
                    onPressed: controller.confirmSelectedGoal,
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

  void _confirmDelete(BuildContext context, SavingGoalEntity goal) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa mục tiêu "${goal.name}"?\nDữ liệu tiết kiệm của các danh mục liên kết vẫn sẽ được giữ lại.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              controller.deleteGoal(goal.id);
              Get.back();
            },
            child: const Text('Xóa mục tiêu', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleUpdate(SavingGoalEntity goal) {
    Get.toNamed(RoutePath.createSavingGoal, arguments: goal);
  }
}
