import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/spending_plan_wizard.dart';

class CreateSpendingPlanScreen extends StatefulWidget {
  const CreateSpendingPlanScreen({super.key});

  @override
  State<CreateSpendingPlanScreen> createState() =>
      _CreateSpendingPlanScreenState();
}

class _CreateSpendingPlanScreenState extends State<CreateSpendingPlanScreen> {
  final SpendingPlanController controller = Get.find<SpendingPlanController>();
  SpendingPlanEntity? _editingPlan;

  @override
  void initState() {
    super.initState();
    final argument = Get.arguments;
    if (argument is SpendingPlanEntity) {
      _editingPlan = argument;
    } else if (argument is Map && argument['isClone'] == true) {
      _editingPlan = argument['plan'] as SpendingPlanEntity?;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialIncome = _editingPlan?.totalAmount ?? 0.0;
    final initialExpenses = _editingPlan?.estimatedExpenses ?? [];

    return Obx(
      () => SpendingPlanWizard(
        initialIncome: initialIncome,
        initialExpenses: initialExpenses,
        isSaving: controller.isSaving.value,
        showWelcomeStep: false,
        saveButtonText: _editingPlan == null
            ? 'Lưu kế hoạch'
            : 'Cập nhật kế hoạch',
        onSave: (income, expenses, wizardController) async {
          final success = _editingPlan == null
              ? await controller.createPlan(
                  wizardController.buildCreateRequest(),
                )
              : await controller.updatePlan(
                  _editingPlan!.id,
                  wizardController.buildUpdateRequest(),
                );

          if (success) {
            Get.back();
          }
        },
      ),
    );
  }
}
