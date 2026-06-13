import 'package:money_care/features/couple/domain/entities/couple_budget_entity.dart';

class CoupleBudgetModel {
  final int id;
  final int coupleId;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final double amount;
  final String month;
  final double spentAmount;
  final double remainingAmount;
  final double usagePercentage;

  CoupleBudgetModel({
    required this.id,
    required this.coupleId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.amount,
    required this.month,
    required this.spentAmount,
    required this.remainingAmount,
    required this.usagePercentage,
  });

  factory CoupleBudgetModel.fromJson(Map<String, dynamic> json) {
    return CoupleBudgetModel(
      id: json['id'] ?? 0,
      coupleId: json['coupleId'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? 'Khác',
      categoryIcon: json['categoryIcon'] ?? '💰',
      amount: double.parse(json['amount']?.toString() ?? '0'),
      month: json['month'] ?? '',
      spentAmount: double.parse(json['spentAmount']?.toString() ?? '0'),
      remainingAmount: double.parse(json['remainingAmount']?.toString() ?? '0'),
      usagePercentage: double.parse(json['usagePercentage']?.toString() ?? '0'),
    );
  }

  CoupleBudgetEntity toEntity() {
    return CoupleBudgetEntity(
      id: id,
      coupleId: coupleId,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      amount: amount,
      month: month,
      spentAmount: spentAmount,
      remainingAmount: remainingAmount,
      usagePercentage: usagePercentage,
    );
  }
}
