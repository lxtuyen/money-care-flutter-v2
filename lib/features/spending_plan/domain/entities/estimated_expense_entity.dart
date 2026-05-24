class EstimatedExpenseEntity {
  final int id;
  final String? category;
  final int? categoryId;
  final String? subCategory;
  final int? subCategoryId;
  final double amount;
  final double monthlyLimit;
  final double? dailyLimit;
  final double spentThisMonth;
  final double todaySpent;
  final double monthlyProgress;
  final double dailyOverAmount;
  final String frequencyType;
  final int frequencyValue;

  const EstimatedExpenseEntity({
    required this.id,
    this.category,
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    required this.amount,
    this.monthlyLimit = 0,
    this.dailyLimit,
    this.spentThisMonth = 0,
    this.todaySpent = 0,
    this.monthlyProgress = 0,
    this.dailyOverAmount = 0,
    required this.frequencyType,
    required this.frequencyValue,
  });

  String get displayName {
    final subCategoryName = subCategory?.trim();
    if (subCategoryName != null && subCategoryName.isNotEmpty) {
      return subCategoryName;
    }
    final categoryName = category?.trim();
    if (categoryName != null && categoryName.isNotEmpty) {
      return categoryName;
    }
    return 'Khoản chi dự kiến';
  }

  EstimatedExpenseEntity copyWith({
    int? id,
    String? category,
    int? categoryId,
    String? subCategory,
    int? subCategoryId,
    double? amount,
    double? monthlyLimit,
    double? dailyLimit,
    double? spentThisMonth,
    double? todaySpent,
    double? monthlyProgress,
    double? dailyOverAmount,
    String? frequencyType,
    int? frequencyValue,
  }) {
    return EstimatedExpenseEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      subCategory: subCategory ?? this.subCategory,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      amount: amount ?? this.amount,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      spentThisMonth: spentThisMonth ?? this.spentThisMonth,
      todaySpent: todaySpent ?? this.todaySpent,
      monthlyProgress: monthlyProgress ?? this.monthlyProgress,
      dailyOverAmount: dailyOverAmount ?? this.dailyOverAmount,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyValue: frequencyValue ?? this.frequencyValue,
    );
  }
}
