import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';

class CoupleSavingsView extends StatelessWidget {
  final CoupleController controller;

  const CoupleSavingsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isSavingsLoading.value &&
            controller.savingGoals.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.savingGoals.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💰', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có quỹ tiết kiệm chung nào.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy cùng partner đặt mục tiêu tiết kiệm chung (đi du lịch, mua nhà, đám cưới...) nhé!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchSavingGoals(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.savingGoals.length,
            itemBuilder: (ctx, index) {
              final goal = controller.savingGoals[index];
              return _buildGoalCard(context, goal);
            },
          ),
        );
      }),
    );
  }

  Widget _buildGoalCard(BuildContext context, CoupleSavingGoalEntity goal) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final progress = goal.target > 0
        ? (goal.savedAmount / goal.target).clamp(0.0, 1.0)
        : 0.0;
    final isCompleted =
        goal.status == 'completed' || goal.savedAmount >= goal.target;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name & Status & Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name.toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.green : Colors.black87,
                        ),
                      ),
                      if (goal.endDate != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Hạn chót: ${DateFormat('dd/MM/yyyy').format(goal.endDate!)}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Hoàn thành',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red[300],
                        size: 20,
                      ),
                      onPressed: () => _confirmDeleteGoal(context, goal),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),

            // Progress Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đã tích lũy: ${AppHelperFunction.formatAmount(goal.savedAmount)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Mục tiêu: ${AppHelperFunction.formatAmount(goal.target)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Đạt ${(progress * 100).toStringAsFixed(1)}% mục tiêu',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 16),

            // Member Breakdown
            Text(
              'ĐÓNG GÓP CỦA TỪNG NGƯỜI',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            ...goal.memberContributions.map((member) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: primaryColor.withOpacity(0.1),
                          child: Text(
                            member.fullName.isNotEmpty
                                ? member.fullName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 9,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          member.fullName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      AppHelperFunction.formatAmount(member.amount),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  foregroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text(
                  'Đóng Góp Quỹ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: () => _showContributeDialog(context, goal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tạo Quỹ Tiết Kiệm Chung'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên mục tiêu',
                        hintText: 'Ví dụ: Đi du lịch Đà Lạt, Mua xe máy...',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: targetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Số tiền mục tiêu (VND)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? 'Chưa chọn hạn chót'
                              : 'Hạn chót: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                const Duration(days: 30),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2035),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                          child: const Text('Chọn ngày'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final target =
                        double.tryParse(targetController.text.trim()) ?? 0.0;
                    if (name.isEmpty) {
                      Get.snackbar('Lỗi', 'Vui lòng nhập tên mục tiêu');
                      return;
                    }
                    if (target <= 0) {
                      Get.snackbar('Lỗi', 'Số tiền mục tiêu phải lớn hơn 0');
                      return;
                    }
                    controller.createSharedSavingGoal(
                      name: name,
                      target: target,
                      endDate: selectedDate,
                    );
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Tạo quỹ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showContributeDialog(
    BuildContext context,
    CoupleSavingGoalEntity goal,
  ) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Đóng Góp Quỹ "${goal.name}"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nhập số tiền bạn muốn đóng góp tích lũy vào quỹ này.',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Số tiền đóng góp (VND)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final amt =
                    double.tryParse(amountController.text.trim()) ?? 0.0;
                if (amt <= 0) {
                  Get.snackbar('Lỗi', 'Số tiền đóng góp phải lớn hơn 0');
                  return;
                }
                controller.addSavingContribution(goalId: goal.id, amount: amt);
                Navigator.of(ctx).pop();
              },
              child: const Text('Đóng góp'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteGoal(BuildContext context, CoupleSavingGoalEntity goal) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xóa Quỹ Tiết Kiệm Chung'),
          content: Text(
            'Bạn có chắc chắn muốn xóa quỹ "${goal.name}"? Dữ liệu đóng góp sẽ bị xóa vĩnh viễn.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteSharedSavingGoal(goal.id);
                Navigator.of(ctx).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
