import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
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
          itemBuilder: (_, index) => _ExpiredGoalCard(
            goal: finishedGoals[index],
            onExtend: () => _extend(context, finishedGoals[index]),
          ),
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
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa mục tiêu "${goal.name}"?\nDữ liệu tiết kiệm của các danh mục liên kết vẫn sẽ được giữ lại.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              controller.deleteGoal(goal.id);
              Get.back();
            },
            child: const Text(
              'Xóa mục tiêu',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _handleUpdate(SavingGoalEntity goal) {
    Get.toNamed(RoutePath.createSavingGoal, arguments: goal);
  }
}

class _ExpiredGoalCard extends StatelessWidget {
  const _ExpiredGoalCard({required this.goal, required this.onExtend});

  final SavingGoalEntity goal;
  final VoidCallback onExtend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(RoutePath.savingGoalDetail, arguments: goal),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: goal.isCompleted
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.name,
                      style: TextStyle(
                        color: goal.isCompleted
                            ? AppColors.income
                            : AppColors.expense,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (goal.isCompleted
                                  ? AppColors.income
                                  : AppColors.expense)
                              .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      goal.isCompleted
                          ? 'Đã hoàn thành'
                          : 'Hết hạn ${goal.daysSinceExpired} ngày trước',
                      style: TextStyle(
                        color: goal.isCompleted
                            ? AppColors.income
                            : AppColors.expense,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _DateChip(
                        label: 'Bắt đầu',
                        value: goal.startDate != null
                            ? AppHelperFunction.getFormattedDate(
                                goal.startDate!,
                              )
                            : '-',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.text5,
                      ),
                      const SizedBox(width: 8),
                      _DateChip(
                        label: goal.isCompleted ? 'Hoàn thành' : 'Dự kiến',
                        value: (goal.isCompleted && goal.updatedAt != null)
                            ? AppHelperFunction.getFormattedDate(
                                goal.updatedAt!,
                              )
                            : (goal.endDate != null
                                  ? AppHelperFunction.getFormattedDate(
                                      goal.endDate!,
                                    )
                                  : '-'),
                        color: goal.isCompleted
                            ? AppColors.income
                            : AppColors.expense,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: AppColors.borderSecondary, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _StatItem(
                        icon: Icons.track_changes_rounded,
                        label: 'Mục tiêu',
                        value: goal.target != null
                            ? AppHelperFunction.formatAmount(
                                goal.target!,
                                currency: 'VND',
                              )
                            : '-',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 24),
                      _StatItem(
                        icon: Icons.savings_outlined,
                        label: 'Đã tiết kiệm',
                        value: AppHelperFunction.formatAmount(
                          goal.savedAmount,
                          currency: 'VND',
                        ),
                        color: goal.isCompleted
                            ? AppColors.income
                            : AppColors.expense,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (!goal.isCompleted)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onExtend,
                            icon: const Icon(Icons.update_rounded, size: 18),
                            label: const Text('Gia hạn'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.text1,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.text4),
          ),
        ],
      ),
    );
  }
}
