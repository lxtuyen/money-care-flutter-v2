import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_saving_goal_card.dart';

class CoupleSavingsView extends StatefulWidget {
  final CoupleController controller;

  const CoupleSavingsView({super.key, required this.controller});

  @override
  State<CoupleSavingsView> createState() => _CoupleSavingsViewState();
}

class _CoupleSavingsViewState extends State<CoupleSavingsView> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return NotificationListener<ScrollNotification>(
      onNotification: (_) => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: _currentTabIndex == 0
            ? FloatingActionButton(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                onPressed: () => Get.toNamed(
                  RoutePath.createSavingGoal,
                  arguments: {'isCouple': true},
                ),
                child: const Icon(Icons.add),
              )
            : null,
        body: Obx(() {
          if (widget.controller.isSavingsLoading.value &&
              widget.controller.savingGoals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildTabBarView();
        }),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Builder(
      builder: (context) {
        final tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging &&
              _currentTabIndex != tabController.index) {
            setState(() {
              _currentTabIndex = tabController.index;
            });
          }
        });

        return TabBarView(
          children: [
            _buildActiveGoalsTab(),
            _buildCompletedGoalsTab(),
          ],
        );
      },
    );
  }

  Widget _buildActiveGoalsTab() {
    return Obx(() {
      final activeGoals = widget.controller.savingGoals
          .where((g) => g.status != 'completed')
          .toList()
        ..sort((a, b) {
          const order = {'active': 0, 'paused': 1};
          return (order[a.status] ?? 1).compareTo(order[b.status] ?? 1);
        });

      if (activeGoals.isEmpty) {
        return Center(
          child: AppEmptyState(
            message: 'Chưa có quỹ tiết kiệm nào đang hoạt động.',
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => widget.controller.fetchSavingGoals(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          itemCount: activeGoals.length,
          itemBuilder: (ctx, index) {
            return CoupleSavingGoalCard(
              goal: activeGoals[index],
              controller: widget.controller,
            );
          },
        ),
      );
    });
  }

  Widget _buildCompletedGoalsTab() {
    return Obx(() {
      final completedGoals = widget.controller.savingGoals
          .where((g) => g.status == 'completed')
          .toList();

      if (completedGoals.isEmpty) {
        return Center(
          child: AppEmptyState(
            message: 'Chưa có quỹ tiết kiệm nào hoàn thành.',
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => widget.controller.fetchSavingGoals(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          itemCount: completedGoals.length,
          itemBuilder: (ctx, index) {
            return CoupleSavingGoalCard(
              goal: completedGoals[index],
              controller: widget.controller,
            );
          },
        ),
      );
    });
  }
}
