import 'package:money_care/features/transaction/data/models/transaction_response_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionByTypeModel {
  final List<TransactionModel> income;
  final List<TransactionModel> expense;

  TransactionByTypeModel({required this.income, required this.expense});

  factory TransactionByTypeModel.fromJson(Map<String, dynamic> json) {
    return TransactionByTypeModel(
      income: (json['income'] as List<dynamic>? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
      expense: (json['expense'] as List<dynamic>? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
    );
  }

  TransactionByTypeEntity toEntity() => TransactionByTypeEntity(
    incomeTransactions: income.map((e) => e.toEntity()).toList(),
    expenseTransactions: expense.map((e) => e.toEntity()).toList(),
  );
}
