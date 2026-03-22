import 'package:money_care/features/transaction/domain/entities/scan_receipt_entity.dart';

class ScanReceiptModel {
  final String rawText;
  final String merchantName;
  final String address;
  final String date;
  final int totalAmount;
  final String currency;
  final String categoryKey;
  final String categoryName;

  ScanReceiptModel({
    required this.rawText,
    required this.merchantName,
    required this.address,
    required this.date,
    required this.totalAmount,
    required this.currency,
    required this.categoryKey,
    required this.categoryName,
  });

  factory ScanReceiptModel.fromJson(Map<String, dynamic> json) {
    return ScanReceiptModel(
      rawText: json['raw_text'] ?? '',
      merchantName: json['merchant_name'] ?? '',
      address: json['address'] ?? '',
      date: json['date'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      currency: json['currency'] ?? '',
      categoryKey: json['category_key'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }

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
