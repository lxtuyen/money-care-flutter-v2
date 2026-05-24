import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/presentation/widgets/saving_goal_item_card.dart';

class SavingGoalManagementScreen extends StatefulWidget {
  final int initialTabIndex;

  const SavingGoalManagementScreen({super.key, this.initialTabIndex = 0});

  @override
  State<SavingGoalManagementScreen> createState() =>
      _SavingGoalManagementScreenState();
}

class _SavingGoalManagementScreenState extends State<SavingGoalManagementScreen>
    with SingleTickerProviderStateMixin {
  final SavingGoalController controller = Get.find<SavingGoalController>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1).toInt(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeSelectGoal();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          controller.saveSelection();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              AppHeader(
                title: 'Mục tiêu tiết kiệm',
                showBackButton: true,
                height: 180,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(text: 'Đang theo dõi'),
                    Tab(text: 'Lịch sử'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildActiveGoalsTab(), _buildFinishedGoalsTab()],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.goToCreateGoal,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActiveGoalsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Obx(() {
            if (controller.isLoadingGoals.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final activeGoals = controller.goals
                .where((goal) => !goal.isExpired)
                .toList(growable: false);

            if (activeGoals.isEmpty) {
              return const AppEmptyState(
                message: 'Bạn chưa thiết lập mục tiêu nào.',
              );
            }

            return ListView.builder(
              itemCount: activeGoals.length,
              itemBuilder: (context, index) {
                final goal = activeGoals[index];
                return Obx(() {
                  final goalIndex = controller.goals.indexWhere(
                    (item) => item.id == goal.id,
                  );
                  final isSelected =
                      controller.selectedGoalIndex.value == goalIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SavingGoalItemCard(
                      fund: goal,
                      isSelected: isSelected,
                      onTap: () =>
                          controller.updateSelectedGoalIndex(goalIndex),
                      onDelete: () => _confirmDelete(context, goal),
                      onUpdate: () => _handleUpdate(goal),
                    ),
                  );
                });
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFinishedGoalsTab() {
    return Obx(() {
      if (controller.isLoadingGoals.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      final finishedGoals = controller.finishedSavingGoals;

      if (finishedGoals.isEmpty) {
        return const AppEmptyState(message: 'Không có mục tiêu hết hạn');
      }

      return RefreshIndicator(
        onRefresh: controller.initializeSelectGoal,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          itemCount: finishedGoals.length,
          itemBuilder: (_, index) {
            final goal = finishedGoals[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SavingGoalItemCard(
                fund: goal,
                isSelected: false,
                onTap: () =>
                    Get.toNamed(RoutePath.savingGoalDetail, arguments: goal),
                onDelete: () => _confirmDelete(context, goal),
                onUpdate: () => _handleUpdate(goal),
                onExtend: () => _extend(context, goal),
              ),
            );
          },
        ),
      );
    });
  }

  Future<void> _extend(BuildContext context, SavingGoalEntity goal) async {
    final newEndDate = await showStyledDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
    );
    if (newEndDate == null) return;
    await controller.extendGoal(goal.id, newEndDate);
    await controller.initializeSelectGoal();
  }

  void _confirmDelete(BuildContext context, SavingGoalEntity goal) {
    AppConfirmDialog.show(
      title: 'Xác nhận xóa',
      message:
          'Bạn có chắc chắn muốn xóa mục tiêu "${goal.name}"?\nDữ liệu tiết kiệm của các danh mục liên kết vẫn sẽ được giữ lại.',
      confirmText: 'Xóa mục tiêu',
      cancelText: 'Hủy',
      onConfirm: () => controller.deleteGoal(goal.id),
    );
  }

  void _handleUpdate(SavingGoalEntity goal) {
    Get.toNamed(RoutePath.createSavingGoal, arguments: goal);
  }
}
