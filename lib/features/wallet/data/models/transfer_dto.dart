import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_dto.freezed.dart';

@freezed
abstract class TransferDto with _$TransferDto {
  const factory TransferDto({
    required int fromWalletId,
    required int toWalletId,
    required double amount,
    String? note,
    int? categoryId,
  }) = _TransferDto;

  const TransferDto._();

  Map<String, dynamic> toJson() {
    final map = {
      'fromWalletId': fromWalletId,
      'toWalletId': toWalletId,
      'amount': amount,
      'note': note,
      'categoryId': categoryId,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
