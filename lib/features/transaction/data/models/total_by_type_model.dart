import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

part 'total_by_type_model.freezed.dart';
part 'total_by_type_model.g.dart';

@freezed
abstract class TotalByTypeModel with _$TotalByTypeModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TotalByTypeModel({
    @JsonKey(name: 'income_total') required int income,
    @JsonKey(name: 'expense_total') required int expense,
    required int currentSaving,
    required int targetSaving,
  }) = _TotalByTypeModel;

  const TotalByTypeModel._();

  factory TotalByTypeModel.fromJson(Map<String, dynamic> json) =>
      _$TotalByTypeModelFromJson(json);

  TotalByTypeEntity toEntity() => TotalByTypeEntity(
        incomeTotal: income,
        expenseTotal: expense,
        currentSaving: currentSaving,
        targetSaving: targetSaving,
      );
}
