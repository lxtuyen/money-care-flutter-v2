import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/spending_plan_summary_card.dart';

class SpendingPlanListScreen extends StatefulWidget {
  const SpendingPlanListScreen({super.key});

  @override
  State<SpendingPlanListScreen> createState() => _SpendingPlanListScreenState();
}

class _SpendingPlanListScreenState extends State<SpendingPlanListScreen> {
  final SpendingPlanController controller = Get.find<SpendingPlanController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPlans();
      controller.loadActivePlan();
    });
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
              const AppHeader(
                title: 'Kế hoạch chi tiêu',
                showBackButton: true,
                height: 140,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.plans.isEmpty) {
                      return const AppEmptyState(
                        message: 'Bạn chưa có kế hoạch chi tiêu nào.',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.loadPlans,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final plan = controller.plans[index];
                          final isSelected =
                              controller.selectedPlanIndex.value == index;

                          return SpendingPlanSummaryCard(
                            plan: plan,
                            isSelected: isSelected,
                            onTap: () =>
                                controller.updateSelectedPlanIndex(index),
                            onDetail: () => _openDetail(plan),
                            onEdit: () => Get.toNamed(
                              RoutePath.createSpendingPlan,
                              arguments: plan,
                            ),
                            onClone: () => Get.toNamed(
                              RoutePath.createSpendingPlan,
                              arguments: {'isClone': true, 'plan': plan},
                            ),
                            onDelete: () => _confirmDelete(context, plan),
                          );
                        },
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 12),
                        itemCount: controller.plans.length,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Get.toNamed(RoutePath.createSpendingPlan),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _openDetail(SpendingPlanEntity plan) {
    Get.toNamed(RoutePath.spendingPlanDetail, arguments: plan.id);
  }

  void _confirmDelete(BuildContext context, SpendingPlanEntity plan) {
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
