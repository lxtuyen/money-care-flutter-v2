import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/statistics/presentation/widgets/estimated_expense_budget_group_card.dart';

class BudgetTrackingSection extends StatelessWidget {
  final SpendingPlanStatsEntity stats;
  final Map<String, List<EstimatedExpenseEntity>> groupedExpenses;

  const BudgetTrackingSection({
    super.key,
    required this.stats,
    required this.groupedExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final statisticsController = Get.find<StatisticsController>();
    final selMonth = statisticsController.selectedMonth.value;
    final daysInMonth = DateTime(selMonth.year, selMonth.month + 1, 0).day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stats.estimatedExpenses.isEmpty)
            const AppEmptyState(
              message: 'Chưa có khoản theo dõi ngân sách nào.',
            )
          else ...[
            ...groupedExpenses.entries.map((entry) {
              return EstimatedExpenseBudgetGroupCard(
                categoryName: entry.key,
                daysInMonth: daysInMonth,
                expenses: entry.value,
              );
            }),
          ],
        ],
      ),
    );
  }
}
