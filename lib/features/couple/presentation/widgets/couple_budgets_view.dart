import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_budget_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_time_navigator.dart';
import 'couple_budget_form.dart';

class CoupleBudgetsView extends StatelessWidget {
  final CoupleController controller;

  const CoupleBudgetsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _showBudgetForm(context),
        child: const Icon(Icons.add_chart_rounded),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Month Selector and Header Info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: AppSectionHeading(
                    title: 'Ngân Sách Chung',
                    showActionButton: false,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => StatisticsTimeNavigator(
                    focusedMonth: controller.selectedMonth.value,
                    onPrevious: () {
                      final current = controller.selectedMonth.value;
                      controller.changeMonth(
                        DateTime(current.year, current.month - 1),
                      );
                    },
                    onNext: () {
                      final current = controller.selectedMonth.value;
                      controller.changeMonth(
                        DateTime(current.year, current.month + 1),
                      );
                    },
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedMonth.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDatePickerMode: DatePickerMode.year,
                      );
                      if (picked != null) {
                        controller.changeMonth(picked);
                      }
                    },
                  ),
                ),
                // Total Summary Card
                Obx(() {
                  if (controller.sharedBudgets.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final double totalLimit = controller.sharedBudgets.fold(0.0, (sum, b) => sum + b.amount);
                  final double totalSpent = controller.totalExpense.value;
                  final double progress = totalLimit > 0 ? (totalSpent / totalLimit).clamp(0.0, 1.0) : 0.0;
                  final double remaining = totalLimit > totalSpent ? totalLimit - totalSpent : 0.0;
                  final bool isExceeded = totalSpent > totalLimit && totalLimit > 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isExceeded ? Colors.red.withValues(alpha: 0.05) : primaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isExceeded ? Colors.red.withValues(alpha: 0.3) : primaryColor.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Tổng Hạn Mức:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                  Text(
                                    AppHelperFunction.formatAmount(totalLimit),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Đã Chi Tiêu:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                  Text(
                                    AppHelperFunction.formatAmount(totalSpent),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isExceeded ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isExceeded ? Colors.red : Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isExceeded ? 'Vượt hạn mức ngân sách!' : 'Còn lại có thể chi:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isExceeded ? FontWeight.bold : FontWeight.normal,
                                      color: isExceeded ? Colors.red : Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    AppHelperFunction.formatAmount(remaining),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: isExceeded ? Colors.red : Colors.black,
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
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Categories budgets list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.sharedBudgets.isEmpty) {
                return const AppEmptyState(
                  message: 'Chưa có ngân sách nào được thiết lập cho tháng này.',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                itemCount: controller.sharedBudgets.length,
                itemBuilder: (context, index) {
                  final budget = controller.sharedBudgets[index];
                  final double limit = budget.amount;
                  final double spent = budget.spentAmount;
                  final double remaining = budget.remainingAmount;
                  final double pct = budget.usagePercentage.clamp(0.0, 100.0);
                  final bool isOver = spent > limit;

                  Color progressColor = Colors.green;
                  if (pct >= 100) {
                    progressColor = Colors.red;
                  } else if (pct >= 80) {
                    progressColor = Colors.orange;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey[150] ?? const Color(0xFFEEEEEE)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row (icon, name, limit, and options)
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: progressColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(budget.categoryIcon, style: const TextStyle(fontSize: 18)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      budget.categoryName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      'Hạn mức: ${AppHelperFunction.formatAmount(limit)}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              // Edit / Delete buttons
                              IconButton(
                                icon: const Icon(Icons.edit_note_rounded, color: Colors.blue, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _showBudgetForm(context, initialBudget: budget),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _confirmDelete(context, budget),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Spending details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Đã tiêu: ${AppHelperFunction.formatAmount(spent)} (${pct.toStringAsFixed(1)}%)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isOver ? Colors.red : Colors.grey[700],
                                  fontWeight: isOver ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Còn lại: ${AppHelperFunction.formatAmount(remaining)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isOver ? Colors.red : Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct / 100.0,
                              minHeight: 6,
                              backgroundColor: Colors.grey[100],
                              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showBudgetForm(BuildContext context, {CoupleBudgetEntity? initialBudget}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CoupleBudgetForm(
          controller: controller,
          initialBudget: initialBudget,
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, CoupleBudgetEntity budget) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xóa ngân sách?'),
          content: Text('Bạn có chắc chắn muốn xóa ngân sách danh mục "${budget.categoryName}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                controller.deleteSharedBudget(budget.id);
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
