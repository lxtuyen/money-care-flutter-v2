import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';

enum GoalPlanImpactStatus { onTrack, delayed }

class BudgetCategoryGoalImpact {
  final String name;
  final GoalPlanImpactStatus status;
  final double plannedToDate;
  final double actualSpent;
  final double overAmount;

  const BudgetCategoryGoalImpact({
    required this.name,
    required this.status,
    required this.plannedToDate,
    required this.actualSpent,
    required this.overAmount,
  });
}

class GoalPlanInsightSnapshot {
  final int userId;
  final String selectedMonth;
  final String goalName;
  final GoalPlanImpactStatus goalStatus;
  final String planName;
  final GoalPlanImpactStatus planStatus;
  final double planPlannedToDate;
  final double planActualSpent;
  final double planOverAmount;
  final List<BudgetCategoryGoalImpact> categories;

  const GoalPlanInsightSnapshot({
    required this.userId,
    required this.selectedMonth,
    required this.goalName,
    required this.goalStatus,
    required this.planName,
    required this.planStatus,
    required this.planPlannedToDate,
    required this.planActualSpent,
    required this.planOverAmount,
    required this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'selectedMonth': selectedMonth,
      'goal': {'name': goalName, 'status': goalStatus.apiValue},
      'plan': {
        'name': planName,
        'status': planStatus.apiValue,
        'plannedToDate': planPlannedToDate,
        'actualSpent': planActualSpent,
        'overAmount': planOverAmount,
      },
      'categories': categories
          .map(
            (item) => {
              'name': item.name,
              'status': item.status.apiValue,
              'plannedToDate': item.plannedToDate,
              'actualSpent': item.actualSpent,
              'overAmount': item.overAmount,
            },
          )
          .toList(),
    };
  }
}

class GoalPlanImpact {
  final GoalPlanImpactStatus status;
  final double plannedToDate;
  final double actualSpent;
  final double overAmount;
  final SpendingPlanStatsEntity stats;
  final DateTime selectedMonth;
  final List<BudgetCategoryGoalImpact> categories;

  const GoalPlanImpact({
    required this.status,
    required this.plannedToDate,
    required this.actualSpent,
    required this.overAmount,
    required this.stats,
    required this.selectedMonth,
    required this.categories,
  });

  static GoalPlanImpact? build({
    required SavingGoalEntity goal,
    required SpendingPlanStatsEntity stats,
    SavingGoalReportModel? report,
    required DateTime selectedMonth,
    required Map<String, List<EstimatedExpenseEntity>> groupedExpenses,
    DateTime? now,
  }) {
    final target = report != null && report.target > 0
        ? report.target
        : goal.target ?? 0;
    final current = report?.currentBalance ?? goal.savedAmount;
    if (target <= 0 || current >= target) return null;

    final daysInMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    ).day;
    final daysPassed = _daysPassedInSelectedMonth(
      selectedMonth,
      daysInMonth,
      now ?? DateTime.now(),
    );
    final monthProgress = daysPassed / daysInMonth;
    final monthlyPlan = stats.totalAmount;
    final plannedToDate = monthlyPlan * monthProgress;
    final actualSpent = stats.spentAmount;
    final overAmount = actualSpent - plannedToDate;
    final status = overAmount > 0
        ? GoalPlanImpactStatus.delayed
        : GoalPlanImpactStatus.onTrack;
    final categoryImpacts = groupedExpenses.entries.map((entry) {
      return categoryImpactFor(
        name: entry.key,
        expenses: entry.value,
        selectedMonth: selectedMonth,
        now: now,
      );
    }).toList();

    return GoalPlanImpact(
      status: status,
      plannedToDate: plannedToDate,
      actualSpent: actualSpent,
      overAmount: overAmount,
      stats: stats,
      selectedMonth: selectedMonth,
      categories: categoryImpacts,
    );
  }

  static BudgetCategoryGoalImpact categoryImpactFor({
    required String name,
    required List<EstimatedExpenseEntity> expenses,
    required DateTime selectedMonth,
    DateTime? now,
  }) {
    final daysInMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    ).day;
    final daysPassed = _daysPassedInSelectedMonth(
      selectedMonth,
      daysInMonth,
      now ?? DateTime.now(),
    );
    final plannedToDate =
        expenses.fold(0.0, (total, expense) {
          return total + _monthlyLimitFor(expense, daysInMonth);
        }) *
        (daysPassed / daysInMonth);
    final actualSpent = expenses.fold(0.0, (total, expense) {
      return total + expense.spentThisMonth;
    });
    final overAmount = actualSpent - plannedToDate;
    final status = overAmount > 0
        ? GoalPlanImpactStatus.delayed
        : GoalPlanImpactStatus.onTrack;

    return BudgetCategoryGoalImpact(
      name: name,
      status: status,
      plannedToDate: plannedToDate,
      actualSpent: actualSpent,
      overAmount: overAmount,
    );
  }

  GoalPlanInsightSnapshot toInsightSnapshot({
    required int userId,
    required SavingGoalEntity goal,
    SavingGoalReportModel? report,
  }) {
    return GoalPlanInsightSnapshot(
      userId: userId,
      selectedMonth:
          '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}',
      goalName: report?.name ?? goal.name,
      goalStatus: status,
      planName: stats.planName,
      planStatus: status,
      planPlannedToDate: plannedToDate,
      planActualSpent: actualSpent,
      planOverAmount: overAmount,
      categories: categories,
    );
  }

  static int _daysPassedInSelectedMonth(
    DateTime selectedMonth,
    int daysInMonth,
    DateTime now,
  ) {
    if (selectedMonth.year == now.year && selectedMonth.month == now.month) {
      return now.day.clamp(1, daysInMonth);
    }
    final selected = DateTime(selectedMonth.year, selectedMonth.month);
    final current = DateTime(now.year, now.month);
    if (selected.isBefore(current)) return daysInMonth;
    return 1;
  }

  static double _monthlyLimitFor(
    EstimatedExpenseEntity expense,
    int daysInMonth,
  ) {
    if (expense.monthlyLimit > 0) {
      return expense.monthlyLimit;
    }
    final frequencyValue = expense.frequencyValue <= 0
        ? 1
        : expense.frequencyValue;
    switch (expense.frequencyType.toLowerCase()) {
      case 'daily':
        return expense.amount * frequencyValue * daysInMonth;
      case 'weekly':
        return expense.amount * frequencyValue * (daysInMonth / 7);
      case 'monthly':
      case 'once':
      default:
        return expense.amount * frequencyValue;
    }
  }
}

extension GoalPlanImpactStatusApi on GoalPlanImpactStatus {
  String get apiValue {
    return switch (this) {
      GoalPlanImpactStatus.onTrack => 'on_track',
      GoalPlanImpactStatus.delayed => 'delayed',
    };
  }

  static GoalPlanImpactStatus fromApi(String? value) {
    return value == 'delayed'
        ? GoalPlanImpactStatus.delayed
        : GoalPlanImpactStatus.onTrack;
  }
}
