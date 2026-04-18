import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/core/utils/helper/num_parser.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

part 'total_by_date_model.freezed.dart';
part 'total_by_date_model.g.dart';

@freezed
abstract class TotalByDateEntityModel with _$TotalByDateEntityModel {
  const factory TotalByDateEntityModel({
    required DateTime date,
    @JsonKey(fromJson: NumParser.parseInt) @Default(0) int total,
  }) = _TotalByDateEntityModel;

  const TotalByDateEntityModel._();

  factory TotalByDateEntityModel.fromJson(Map<String, dynamic> json) =>
      _$TotalByDateEntityModelFromJson(json);

  TotalByDateEntity toEntity() => TotalByDateEntity(date: date, total: total);
}
