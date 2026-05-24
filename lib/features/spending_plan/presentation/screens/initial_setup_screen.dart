import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/spending_plan_wizard.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final SpendingPlanController controller = Get.find<SpendingPlanController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SpendingPlanWizard(
        initialIncome: 0,
        initialExpenses: const [],
        isSaving: controller.isSaving.value,
        showWelcomeStep: true,
        saveButtonText: 'Lưu kế hoạch',
        onSave: (income, expenses, wizardController) async {
          final success = await controller.createPlan(
            wizardController.buildCreateRequest(),
          );

          if (success) {
            final createdPlan = controller.selectedPlan.value;
            if (createdPlan != null) {
              await controller.activatePlan(createdPlan.id);
            }
            if (Get.isRegistered<AuthController>()) {
              await Get.find<AuthController>()
                  .markInitialFinancialSetupCompleted();
            }
            Get.offAllNamed(RoutePath.main);
          }
        },
      ),
    );
  }
}
