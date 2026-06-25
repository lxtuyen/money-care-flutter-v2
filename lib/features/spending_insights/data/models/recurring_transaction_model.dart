import 'package:money_care/features/spending_insights/domain/entities/recurring_transaction_entity.dart';

class RecurringTransactionModel {
  final String recurringId;
  final int? confirmedId;
  final String categoryName;
  final String categoryIcon;
  final String description;
  final double averageAmount;
  final String frequency;
  final double confidence;
  final String lastOccurrence;
  final String nextExpectedDate;
  final int occurrenceCount;
  final double totalSpent;
  final double monthlyEstimate;
  final String amountTrend;
  final List<Map<String, dynamic>> recentTransactions;
  final int? expectedDay;

  const RecurringTransactionModel({
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

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecurringTransactionModel(
      recurringId: json['recurringId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      categoryIcon: json['categoryIcon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      averageAmount: (json['averageAmount'] as num? ?? 0.0).toDouble(),
      frequency: json['frequency']?.toString() ?? 'monthly',
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      lastOccurrence: json['lastOccurrence']?.toString() ?? '',
      nextExpectedDate: json['nextExpectedDate']?.toString() ?? '',
      occurrenceCount: json['occurrenceCount'] as int? ?? 0,
      totalSpent: (json['totalSpent'] as num? ?? 0.0).toDouble(),
      monthlyEstimate: (json['monthlyEstimate'] as num? ?? 0.0).toDouble(),
      amountTrend: json['amountTrend']?.toString() ?? 'stable',
      recentTransactions: (json['recentTransactions'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          <Map<String, dynamic>>[],
      expectedDay: json['expectedDay'] as int?,
    );
  }

  RecurringTransactionEntity toEntity() {
    return RecurringTransactionEntity(
      recurringId: recurringId,
      confirmedId: confirmedId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      description: description,
      averageAmount: averageAmount,
      frequency: frequency,
      confidence: confidence,
      lastOccurrence: lastOccurrence,
      nextExpectedDate: nextExpectedDate,
      occurrenceCount: occurrenceCount,
      totalSpent: totalSpent,
      monthlyEstimate: monthlyEstimate,
      amountTrend: amountTrend,
      recentTransactions: recentTransactions
          .map(
            (tx) => RecentTransactionItem(
              id: tx['id'] as int? ?? 0,
              amount: (tx['amount'] as num? ?? 0.0).toDouble(),
              date: tx['date']?.toString() ?? '',
              note: tx['note']?.toString() ?? '',
            ),
          )
          .toList(),
      expectedDay: expectedDay,
    );
  }

  /// Parse from confirmed DB record (simpler shape, no AI-specific fields).
  factory RecurringTransactionModel.fromConfirmedJson(
    Map<String, dynamic> json,
  ) {
    return RecurringTransactionModel(
      recurringId: json['aiRecurringId']?.toString() ?? json['id']?.toString() ?? '',
      confirmedId: json['id'] as int?,
      categoryName: json['categoryName']?.toString() ?? '',
      categoryIcon: json['categoryIcon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      averageAmount: double.tryParse(json['averageAmount']?.toString() ?? '') ?? 0.0,
      frequency: json['frequency']?.toString() ?? 'monthly',
      confidence: 1.0,
      lastOccurrence: '',
      nextExpectedDate: '',
      occurrenceCount: 0,
      totalSpent: 0.0,
      monthlyEstimate: double.tryParse(json['monthlyEstimate']?.toString() ?? '') ?? 0.0,
      amountTrend: 'stable',
      recentTransactions: <Map<String, dynamic>>[],
      expectedDay: json['expectedDay'] as int?,
    );
  }
}

class RecurringDetectResponseModel {
  final List<RecurringTransactionModel> recurringItems;
  final double totalMonthlyRecurring;
  final int scanMonths;
  final int transactionCount;
  final String? lastScannedAt;

  const RecurringDetectResponseModel({
    required this.recurringItems,
    required this.totalMonthlyRecurring,
    required this.scanMonths,
    required this.transactionCount,
    this.lastScannedAt,
  });

  factory RecurringDetectResponseModel.fromJson(Map<String, dynamic> json) {
    return RecurringDetectResponseModel(
      recurringItems: (json['recurringItems'] as List?)
              ?.map(
                (e) => RecurringTransactionModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          <RecurringTransactionModel>[],
      totalMonthlyRecurring:
          (json['totalMonthlyRecurring'] as num? ?? 0.0).toDouble(),
      scanMonths: json['scanMonths'] as int? ?? 0,
      transactionCount: json['transactionCount'] as int? ?? 0,
      lastScannedAt: json['lastScannedAt'] as String?,
    );
  }

  RecurringDetectResult toEntity() {
    return RecurringDetectResult(
      recurringItems: recurringItems.map((m) => m.toEntity()).toList(),
      totalMonthlyRecurring: totalMonthlyRecurring,
      scanMonths: scanMonths,
      transactionCount: transactionCount,
      lastScannedAt: lastScannedAt,
    );
  }
}
