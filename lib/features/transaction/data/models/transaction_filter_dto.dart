import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_filter_dto.freezed.dart';
part 'transaction_filter_dto.g.dart';

@freezed
class TransactionFilterDto with _$TransactionFilterDto {
  @JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
  const factory TransactionFilterDto({
    @JsonKey(name: 'categoryId') int? categoryId,
    @JsonKey(name: 'fundId') int? fundId,
    String? startDate,
    String? endDate,
  }) = _TransactionFilterDto;

  const TransactionFilterDto._();

  factory TransactionFilterDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionFilterDtoFromJson(json);

  Map<String, dynamic> toQueryParams() => toJson();
}
