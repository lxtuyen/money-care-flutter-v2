import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_create_dto.freezed.dart';
part 'transaction_create_dto.g.dart';

@freezed
class TransactionCreateDto with _$TransactionCreateDto {
  const factory TransactionCreateDto({
    int? amount,
    String? type,
    String? note,
    @JsonKey(name: 'pictuteURL') String? pictureUrl,
    DateTime? transactionDate,
    int? categoryId,
    int? userId,
    int? fundId,
  }) = _TransactionCreateDto;

  factory TransactionCreateDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionCreateDtoFromJson(json);
}
