import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_saving_goal_card.dart';

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
        onPressed: () => Get.toNamed(
          RoutePath.createSavingGoal,
          arguments: {'isCouple': true},
        ),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isSavingsLoading.value &&
            controller.savingGoals.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.savingGoals.isEmpty) {
          return Center(
            child: AppEmptyState(message: 'Chưa có quỹ tiết kiệm chung nào.'),
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
              return CoupleSavingGoalCard(
                goal: goal,
                controller: controller,
              );
            },
          ),
        );
      }),
    );
  }
}
