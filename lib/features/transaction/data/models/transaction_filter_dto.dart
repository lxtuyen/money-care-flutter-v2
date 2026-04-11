import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_filter_dto.freezed.dart';
part 'transaction_filter_dto.g.dart';

@freezed
abstract class TransactionFilterDto with _$TransactionFilterDto {
  const factory TransactionFilterDto({
    @JsonKey(name: 'categoryId') int? categoryId,
    @JsonKey(name: 'fundId') int? fundId,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
  }) = _TransactionFilterDto;

  const TransactionFilterDto._();

  factory TransactionFilterDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionFilterDtoFromJson(json);

  Map<String, dynamic> toQueryParams() => toJson();
}
