import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/transaction/data/models/total_by_date_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

part 'totals_by_date_model.freezed.dart';
part 'totals_by_date_model.g.dart';

@freezed
class TotalsByDateEntityModel with _$TotalsByDateEntityModel {
  const factory TotalsByDateEntityModel({
    @Default([]) List<TotalByDateEntityModel> income,
    @Default([]) List<TotalByDateEntityModel> expense,
  }) = _TotalsByDateEntityModel;

  const TotalsByDateEntityModel._();

  factory TotalsByDateEntityModel.fromJson(Map<String, dynamic> json) =>
      _$TotalsByDateEntityModelFromJson(json);

  TotalsByDateEntity toEntity() => TotalsByDateEntity(
        income: income.map((e) => e.toEntity()).toList(),
        expense: expense.map((e) => e.toEntity()).toList(),
      );
}
