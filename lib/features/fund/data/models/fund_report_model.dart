class CategorySpendingModel {
  final int categoryId;
  final String categoryName;
  final double totalSpent;
  final int transactionCount;
  final int percentage;

  CategorySpendingModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalSpent,
    required this.transactionCount,
    required this.percentage,
  });

  factory CategorySpendingModel.fromMap(Map<String, dynamic> json) {
    return CategorySpendingModel(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      totalSpent: double.tryParse(json['total_spent'].toString()) ?? 0,
      transactionCount: json['transaction_count'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}

class FundReportModel {
  final int fundId;
  final String fundName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final double balance;
  final double target;
  final double totalSpent;
  final double remainingBudget;
  final int balanceUsagePercentage;
  final int targetCompletionPercentage;
  final bool isOverBudget;
  final bool isTargetAchieved;
  final List<CategorySpendingModel> categoryBreakdown;
  final int totalTransactions;
  final double averageTransactionAmount;
  final int durationDays;
  final double dailyAverageSpending;

  FundReportModel({
    required this.fundId,
    required this.fundName,
    this.startDate,
    this.endDate,
    required this.status,
    required this.balance,
    required this.target,
    required this.totalSpent,
    required this.remainingBudget,
    required this.balanceUsagePercentage,
    required this.targetCompletionPercentage,
    required this.isOverBudget,
    required this.isTargetAchieved,
    required this.categoryBreakdown,
    required this.totalTransactions,
    required this.averageTransactionAmount,
    required this.durationDays,
    required this.dailyAverageSpending,
  });

  factory FundReportModel.fromMap(Map<String, dynamic> json) {
    return FundReportModel(
      fundId: json['fund_id'],
      fundName: json['fund_name'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'] ?? 'EXPIRED',
      balance: double.tryParse(json['balance'].toString()) ?? 0,
      target: double.tryParse(json['target'].toString()) ?? 0,
      totalSpent: double.tryParse(json['total_spent'].toString()) ?? 0,
      remainingBudget: double.tryParse(json['remaining_balance'].toString()) ?? 0,
      balanceUsagePercentage: json['balance_usage_percentage'] ?? 0,
      targetCompletionPercentage: json['target_completion_percentage'] ?? 0,
      isOverBudget: json['is_over_balance'] ?? false,
      isTargetAchieved: json['is_target_achieved'] ?? false,
      categoryBreakdown: (json['category_breakdown'] as List? ?? [])
          .map((e) => CategorySpendingModel.fromMap(e))
          .toList(),
      totalTransactions: json['total_transactions'] ?? 0,
      averageTransactionAmount:
          double.tryParse(json['average_transaction_amount'].toString()) ?? 0,
      durationDays: json['duration_days'] ?? 0,
      dailyAverageSpending:
          double.tryParse(json['daily_average_spending'].toString()) ?? 0,
    );
  }
}
