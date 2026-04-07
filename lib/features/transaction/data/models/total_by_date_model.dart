import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

part 'total_by_date_model.freezed.dart';
part 'total_by_date_model.g.dart';

@freezed
class TotalByDateEntityModel with _$TotalByDateEntityModel {
  const factory TotalByDateEntityModel({
    required DateTime date,
    @Default(0) int total,
  }) = _TotalByDateEntityModel;

  const TotalByDateEntityModel._();

  factory TotalByDateEntityModel.fromJson(Map<String, dynamic> json) =>
      _$TotalByDateEntityModelFromJson(json);

  TotalByDateEntity toEntity() => TotalByDateEntity(date: date, total: total);
}
