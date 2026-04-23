import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/transaction/data/models/transaction_response_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

part 'transaction_by_type_model.freezed.dart';
part 'transaction_by_type_model.g.dart';

@freezed
abstract class TransactionByTypeModel with _$TransactionByTypeModel {
  const factory TransactionByTypeModel({
    @Default([]) List<TransactionModel> income,
    @Default([]) List<TransactionModel> expense,
  }) = _TransactionByTypeModel;

  const TransactionByTypeModel._();

  factory TransactionByTypeModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionByTypeModelFromJson(json);

  TransactionByTypeEntity toEntity() => TransactionByTypeEntity(
    incomeTransactions: income.map((e) => e.toEntity()).toList(),
    expenseTransactions: expense.map((e) => e.toEntity()).toList(),
  );
}
