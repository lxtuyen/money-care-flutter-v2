import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/button/app_action_button.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/statistics/presentation/widgets/estimated_expense_budget_group_card.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/spending_plan_summary_card.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/estimated_expense_edit_sheet.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/estimated_expense_detail.dart';

class SpendingPlanDetailScreen extends StatefulWidget {
  const SpendingPlanDetailScreen({super.key});

  @override
  State<SpendingPlanDetailScreen> createState() =>
      _SpendingPlanDetailScreenState();
}

class _SpendingPlanDetailScreenState extends State<SpendingPlanDetailScreen> {
  final SpendingPlanController controller = Get.find<SpendingPlanController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final argument = Get.arguments;
      if (argument is int) {
        controller.loadPlan(argument);
      } else if (argument is SpendingPlanEntity) {
        controller.selectedPlan.value = argument;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(
              title: 'Chi tiết kế hoạch',
              showBackButton: true,
              height: 140,
            ),
            Expanded(
              child: Obx(() {
                final plan = controller.selectedPlan.value;
                if (controller.isLoading.value && plan == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (plan == null) {
                  return const Center(child: Text('Không tìm thấy kế hoạch'));
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SpendingPlanSummaryCard(plan: plan),
                    const SizedBox(height: 12),
                    _PlanActions(plan: plan, controller: controller),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Khoản chi dự kiến',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (plan.estimatedExpenses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Chưa có khoản chi dự kiến.'),
                      )
                    else ...[
                      ...EstimatedExpenseBudgetGroupCard.groupExpenses(
                        plan.estimatedExpenses,
                      ).entries.map((entry) {
                        return EstimatedExpenseBudgetGroupCard(
                          categoryName: entry.key,
                          daysInMonth: DateTime(
                            plan.year,
                            plan.month + 1,
                            0,
                          ).day,
                          expenses: entry.value,
                          onExpenseTap: (expense) =>
                              EstimatedExpenseDetail.show(
                                context,
                                plan: plan,
                                expense: expense,
                              ),
                        );
                      }),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        final plan = controller.selectedPlan.value;
        if (plan == null) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => EstimatedExpenseEditSheet(plan: plan),
            );
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Obx(() {
          final plan = controller.selectedPlan.value;
          if (plan == null) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              label: plan.isActive ? 'Tạm dừng kế hoạch' : 'Áp dụng kế hoạch',
              isLoading: controller.isSaving.value,
              onPressed: plan.isActive
                  ? () => controller.pausePlan(plan.id)
                  : () => controller.activatePlan(plan.id),
            ),
          );
        }),
      ),
    );
  }
}

class _PlanActions extends StatelessWidget {
  final SpendingPlanEntity plan;
  final SpendingPlanController controller;

  const _PlanActions({required this.plan, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppActionButton(
            onTap: () => Get.toNamed(
                RoutePath.createSpendingPlan,
                arguments: plan,
              ),
            icon: Icons.edit_outlined,
            label: 'Cập nhật',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppActionButton(
            onTap: () => Get.toNamed(
                RoutePath.createSpendingPlan,
                arguments: {'isClone': true, 'plan': plan},
              ),
            icon: Icons.copy_rounded,
            label: 'Nhân bản',
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppActionButton(
            onTap: () => _confirmDelete(context),
            icon: Icons.delete_outline_rounded,
            label: 'Xóa',
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    AppConfirmDialog.show(
      title: 'Xóa kế hoạch chi tiêu?',
      message:
          'Kế hoạch và các khoản chi dự kiến bên trong sẽ bị xóa. Thao tác này không thể hoàn tác.',
      confirmText: 'Xóa',
      cancelText: 'Hủy',
      onConfirm: () async {
        final success = await controller.deletePlan(plan.id);
        if (success) {
          Get.back();
        }
      },
    );
  }
}
