import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_filter_dto.freezed.dart';
part 'transaction_filter_dto.g.dart';

@freezed
abstract class TransactionFilterDto with _$TransactionFilterDto {
  const factory TransactionFilterDto({
    @JsonKey(name: 'categoryId') int? categoryId,
    @JsonKey(name: 'savingGoalId') int? goalId,
    @JsonKey(name: 'startDate') String? startDate,
    @JsonKey(name: 'endDate') String? endDate,
    @JsonKey(name: 'limit') int? limit,
  }) = _TransactionFilterDto;

  const TransactionFilterDto._();

  factory TransactionFilterDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionFilterDtoFromJson(json);

  Map<String, dynamic> toQueryParams() => toJson();
}
