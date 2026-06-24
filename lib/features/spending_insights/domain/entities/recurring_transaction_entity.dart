class RecurringTransactionEntity {
  final String recurringId;
  final int? confirmedId; // DB primary key (only for confirmed items)
  final String categoryName;
  final String categoryIcon;
  final String description;
  final double averageAmount;
  final String frequency; // weekly | bi_weekly | monthly
  final double confidence;
  final String lastOccurrence;
  final String nextExpectedDate;
  final int occurrenceCount;
  final double totalSpent;
  final double monthlyEstimate;
  final String amountTrend; // stable | increasing | decreasing
  final List<RecentTransactionItem> recentTransactions;
  final int? expectedDay;

  const RecurringTransactionEntity({
    required this.recurringId,
    this.confirmedId,
    required this.categoryName,
    required this.categoryIcon,
    required this.description,
    required this.averageAmount,
    required this.frequency,
    required this.confidence,
    required this.lastOccurrence,
    required this.nextExpectedDate,
    required this.occurrenceCount,
    required this.totalSpent,
    required this.monthlyEstimate,
    required this.amountTrend,
    required this.recentTransactions,
    this.expectedDay,
  });

  String get frequencyLabel {
    switch (frequency) {
      case 'weekly':
        return 'Hàng tuần';
      case 'bi_weekly':
        return '2 tuần/lần';
      case 'monthly':
        return 'Hàng tháng';
      default:
        return frequency;
    }
  }

  String get trendLabel {
    switch (amountTrend) {
      case 'increasing':
        return 'Tăng';
      case 'decreasing':
        return 'Giảm';
      default:
        return 'Ổn định';
    }
  }
}

class RecentTransactionItem {
  final int id;
  final double amount;
  final String date;
  final String note;

  const RecentTransactionItem({
    required this.id,
    required this.amount,
    required this.date,
    required this.note,
  });
}

class RecurringDetectResult {
  final List<RecurringTransactionEntity> recurringItems;
  final double totalMonthlyRecurring;
  final int scanMonths;
  final int transactionCount;
  final String? lastScannedAt;

  const RecurringDetectResult({
    required this.recurringItems,
    required this.totalMonthlyRecurring,
    required this.scanMonths,
    required this.transactionCount,
    this.lastScannedAt,
  });
}
