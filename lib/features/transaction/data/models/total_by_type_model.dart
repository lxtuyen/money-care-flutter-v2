import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TotalByTypeModel {
  final int income;
  final int expense;

  TotalByTypeModel({required this.income, required this.expense});

  factory TotalByTypeModel.fromJson(Map<String, dynamic> json) {
    return TotalByTypeModel(
      income: (json['income_total'] ?? 0).toInt(),
      expense: (json['expense_total'] ?? 0).toInt(),
    );
  }

  TotalByTypeEntity toEntity() =>
      TotalByTypeEntity(incomeTotal: income, expenseTotal: expense);
}
