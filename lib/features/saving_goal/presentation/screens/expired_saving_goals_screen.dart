import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';

class ExpiredSavingGoalsScreen extends StatefulWidget {
  const ExpiredSavingGoalsScreen({super.key});

  @override
  State<ExpiredSavingGoalsScreen> createState() =>
      _ExpiredSavingGoalsScreenState();
}

class _ExpiredSavingGoalsScreenState extends State<ExpiredSavingGoalsScreen> {
  final SavingGoalController controller = Get.find<SavingGoalController>();
  final AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final userId = appController.userId.value;
    if (userId != null) {
      await controller.loadGoals(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          const AppHeader(
            title: 'Lịch sử mục tiêu tiết kiệm',
            showBackButton: true,
            height: 130,
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingGoals.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final expired = controller.finishedSavingGoals;

              if (expired.isEmpty) {
                return _buildEmpty();
              }

              return RefreshIndicator(
                onRefresh: _load,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: expired.length,
                  itemBuilder: (_, i) => _ExpiredGoalCard(
                    goal: expired[i],
                    onExtend: () => _extend(context, expired[i]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 40,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Không có mục tiêu hết hạn',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tất cả mục tiêu tiết kiệm của bạn vẫn còn thời hạn',
            style: TextStyle(fontSize: 13, color: AppColors.text4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _extend(BuildContext context, SavingGoalEntity goal) async {
    final newEndDate = await showStyledDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
    );
    if (newEndDate == null) return;
    await controller.extendGoal(goal.id, newEndDate);
    await _load();
  }
}

class _ExpiredGoalCard extends StatelessWidget {
  const _ExpiredGoalCard({required this.goal, required this.onExtend});

  final SavingGoalEntity goal;
  final VoidCallback onExtend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              gradient: LinearGradient(
                colors: goal.isCompleted
                    ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
                    : [const Color(0xFFFF7D39), const Color(0xFFFF4E4E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(
                  goal.isCompleted
                      ? Icons.workspace_premium_rounded
                      : Icons.timer_off_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    goal.name,
                    style: const TextStyle(
                      color: Colors.white,
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
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    goal.isCompleted
                        ? 'Đã hoàn thành'
                        : 'Hết hạn ${goal.daysSinceExpired} ngày trước',
                    style: const TextStyle(
                      color: Colors.white,
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
                      icon: Icons.play_circle_outline_rounded,
                      label: 'Bắt đầu',
                      value: goal.startDate != null
                          ? AppHelperFunction.getFormattedDate(goal.startDate!)
                          : '—',
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
                      icon: goal.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.stop_circle_outlined,
                      label: goal.isCompleted ? 'Hoàn thành' : 'Dự kiến',
                      value: (goal.isCompleted && goal.updatedAt != null)
                          ? AppHelperFunction.getFormattedDate(goal.updatedAt!)
                          : (goal.endDate != null
                                ? AppHelperFunction.getFormattedDate(
                                    goal.endDate!,
                                  )
                                : '—'),
                      color: goal.isCompleted
                          ? AppColors.success
                          : AppColors.secondaryOrange,
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
                          ? AppHelperFunction.formatAmount(goal.target!, 'VND')
                          : '—',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 24),
                    _StatItem(
                      icon: Icons.savings_outlined,
                      label: 'Đã tiết kiệm',
                      value: AppHelperFunction.formatAmount(
                        goal.savedAmount,
                        'VND',
                      ),
                      color: AppColors.success,
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
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: color.withOpacity(0.8),
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
              color: color.withOpacity(0.1),
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
