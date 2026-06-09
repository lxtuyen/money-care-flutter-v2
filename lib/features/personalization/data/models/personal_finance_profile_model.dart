class PersonalFinanceProfileModel {
  final int id;
  final int userId;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? generatedAt;
  final double averageMonthlyIncome;
  final double averageMonthlyExpense;
  final double averageMonthlySavings;
  final double savingsRate;
  final double expenseVolatilityScore;
  final double budgetDisciplineScore;
  final double financialHealthScore;
  final String riskLevel;
  final String spendingStyle;
  final List<dynamic> topExpenseCategories;
  final List<dynamic> essentialCategories;
  final List<dynamic> recurringExpenseHints;
  final List<dynamic> frequentExpenseDays;
  final String monthlyIncomeTrend;
  final String monthlyExpenseTrend;
  final double preferredBudgetBufferPct;
  final double confidenceScore;
  final Map<String, dynamic> feedbackSummary;
  final String profileVersion;

  PersonalFinanceProfileModel({
    required this.id,
    required this.userId,
    this.periodStart,
    this.periodEnd,
    this.generatedAt,
    required this.averageMonthlyIncome,
    required this.averageMonthlyExpense,
    required this.averageMonthlySavings,
    required this.savingsRate,
    required this.expenseVolatilityScore,
    required this.budgetDisciplineScore,
    required this.financialHealthScore,
    required this.riskLevel,
    required this.spendingStyle,
    required this.topExpenseCategories,
    required this.essentialCategories,
    required this.recurringExpenseHints,
    required this.frequentExpenseDays,
    required this.monthlyIncomeTrend,
    required this.monthlyExpenseTrend,
    required this.preferredBudgetBufferPct,
    required this.confidenceScore,
    required this.feedbackSummary,
    required this.profileVersion,
  });

  factory PersonalFinanceProfileModel.fromJson(Map<String, dynamic> json) {
    return PersonalFinanceProfileModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      periodStart: json['periodStart'] != null
          ? DateTime.parse(json['periodStart'])
          : null,
      periodEnd: json['periodEnd'] != null
          ? DateTime.parse(json['periodEnd'])
          : null,
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'])
          : null,
      averageMonthlyIncome: (json['averageMonthlyIncome'] ?? 0).toDouble(),
      averageMonthlyExpense: (json['averageMonthlyExpense'] ?? 0).toDouble(),
      averageMonthlySavings: (json['averageMonthlySavings'] ?? 0).toDouble(),
      savingsRate: (json['savingsRate'] ?? 0).toDouble(),
      expenseVolatilityScore: (json['expenseVolatilityScore'] ?? 0).toDouble(),
      budgetDisciplineScore: (json['budgetDisciplineScore'] ?? 0).toDouble(),
      financialHealthScore: (json['financialHealthScore'] ?? 0).toDouble(),
      riskLevel: json['riskLevel'] ?? 'medium',
      spendingStyle: json['spendingStyle'] ?? 'insufficient_data',
      topExpenseCategories: json['topExpenseCategories'] ?? [],
      essentialCategories: json['essentialCategories'] ?? [],
      recurringExpenseHints: json['recurringExpenseHints'] ?? [],
      frequentExpenseDays: json['frequentExpenseDays'] ?? [],
      monthlyIncomeTrend: json['monthlyIncomeTrend'] ?? 'stable',
      monthlyExpenseTrend: json['monthlyExpenseTrend'] ?? 'stable',
      preferredBudgetBufferPct: (json['preferredBudgetBufferPct'] ?? 0.1)
          .toDouble(),
      confidenceScore: (json['confidenceScore'] ?? 0).toDouble(),
      feedbackSummary: json['feedbackSummary'] is Map<String, dynamic>
          ? json['feedbackSummary'] as Map<String, dynamic>
          : <String, dynamic>{},
      profileVersion: json['profileVersion'] ?? 'v1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'periodStart': periodStart?.toIso8601String(),
      'periodEnd': periodEnd?.toIso8601String(),
      'generatedAt': generatedAt?.toIso8601String(),
      'averageMonthlyIncome': averageMonthlyIncome,
      'averageMonthlyExpense': averageMonthlyExpense,
      'averageMonthlySavings': averageMonthlySavings,
      'savingsRate': savingsRate,
      'expenseVolatilityScore': expenseVolatilityScore,
      'budgetDisciplineScore': budgetDisciplineScore,
      'financialHealthScore': financialHealthScore,
      'riskLevel': riskLevel,
      'spendingStyle': spendingStyle,
      'topExpenseCategories': topExpenseCategories,
      'essentialCategories': essentialCategories,
      'recurringExpenseHints': recurringExpenseHints,
      'frequentExpenseDays': frequentExpenseDays,
      'monthlyIncomeTrend': monthlyIncomeTrend,
      'monthlyExpenseTrend': monthlyExpenseTrend,
      'preferredBudgetBufferPct': preferredBudgetBufferPct,
      'confidenceScore': confidenceScore,
      'feedbackSummary': feedbackSummary,
      'profileVersion': profileVersion,
    };
  }
}
