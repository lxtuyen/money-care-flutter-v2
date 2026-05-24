class CreateEstimatedExpenseRequest {
  final String? category;
  final int? categoryId;
  final String? subCategory;
  final int? subCategoryId;
  final double amount;
  final double? monthlyLimit;
  final double? dailyLimit;
  final String? frequencyType;
  final int? frequencyValue;

  const CreateEstimatedExpenseRequest({
    this.category,
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    required this.amount,
    this.monthlyLimit,
    this.dailyLimit,
    this.frequencyType,
    this.frequencyValue,
  });

  Map<String, dynamic> toJson() {
    return {
      if (category != null) 'category': category,
      if (categoryId != null) 'categoryId': categoryId,
      if (subCategoryId != null) 'subCategoryId': subCategoryId,
      'amount': amount,
      if (monthlyLimit != null) 'monthlyLimit': monthlyLimit,
      'dailyLimit': dailyLimit,
      if (frequencyType != null) 'frequencyType': frequencyType,
      if (frequencyValue != null) 'frequencyValue': frequencyValue,
    };
  }
}

class CreateSpendingPlanRequest {
  final double totalAmount;
  final List<CreateEstimatedExpenseRequest> estimatedExpenses;

  const CreateSpendingPlanRequest({
    required this.totalAmount,
    required this.estimatedExpenses,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'estimatedExpenses': estimatedExpenses
          .map((expense) => expense.toJson())
          .toList(),
    };
  }
}

class UpdateSpendingPlanRequest {
  final double? totalAmount;
  final List<CreateEstimatedExpenseRequest>? estimatedExpenses;

  const UpdateSpendingPlanRequest({this.totalAmount, this.estimatedExpenses});

  Map<String, dynamic> toJson() {
    return {
      if (totalAmount != null) 'totalAmount': totalAmount,
      if (estimatedExpenses != null)
        'estimatedExpenses': estimatedExpenses!
            .map((expense) => expense.toJson())
            .toList(),
    };
  }
}
