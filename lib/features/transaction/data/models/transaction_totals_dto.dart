import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_totals_dto.freezed.dart';
part 'transaction_totals_dto.g.dart';

@freezed
abstract class TransactionTotalsDto with _$TransactionTotalsDto {
  const factory TransactionTotalsDto({
    @JsonKey(name: 'savingGoalId') int? goalId,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    String? type,
  }) = _TransactionTotalsDto;

  factory TransactionTotalsDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionTotalsDtoFromJson(json);
}
