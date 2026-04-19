import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_totals_dto.freezed.dart';
part 'transaction_totals_dto.g.dart';

@freezed
abstract class TransactionTotalsDto with _$TransactionTotalsDto {
  const factory TransactionTotalsDto({
    @JsonKey(name: 'savingGoalId') int? goalId,
    @JsonKey(name: 'startDate') String? startDate,
    @JsonKey(name: 'endDate') String? endDate,
    String? type,
  }) = _TransactionTotalsDto;

  factory TransactionTotalsDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionTotalsDtoFromJson(json);
}
