import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_totals_dto.freezed.dart';
part 'transaction_totals_dto.g.dart';

@freezed
class TransactionTotalsDto with _$TransactionTotalsDto {
  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory TransactionTotalsDto({
    @JsonKey(name: 'fundId') int? fundId,
    String? startDate,
    String? endDate,
    String? type,
  }) = _TransactionTotalsDto;

  factory TransactionTotalsDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionTotalsDtoFromJson(json);
}
