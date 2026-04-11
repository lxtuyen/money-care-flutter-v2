import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';

part 'scan_receipt_model.freezed.dart';
part 'scan_receipt_model.g.dart';

@freezed
abstract class ScanReceiptModel with _$ScanReceiptModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ScanReceiptModel({
    required String rawText,
    required String merchantName,
    required String address,
    required String date,
    required int totalAmount,
    required String currency,
    required String categoryKey,
    required String categoryName,
  }) = _ScanReceiptModel;

  const ScanReceiptModel._();

  factory ScanReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$ScanReceiptModelFromJson(json);

  ScanReceiptEntity toEntity() => ScanReceiptEntity(
        rawText: rawText,
        merchantName: merchantName,
        address: address,
        date: date,
        totalAmount: totalAmount,
        currency: currency,
        categoryKey: categoryKey,
        categoryName: categoryName,
      );
}
