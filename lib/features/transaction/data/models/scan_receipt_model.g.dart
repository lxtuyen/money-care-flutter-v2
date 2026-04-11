// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanReceiptModel _$ScanReceiptModelFromJson(Map<String, dynamic> json) =>
    _ScanReceiptModel(
      rawText: json['raw_text'] as String,
      merchantName: json['merchant_name'] as String,
      address: json['address'] as String,
      date: json['date'] as String,
      totalAmount: (json['total_amount'] as num).toInt(),
      currency: json['currency'] as String,
      categoryKey: json['category_key'] as String,
      categoryName: json['category_name'] as String,
    );

Map<String, dynamic> _$ScanReceiptModelToJson(_ScanReceiptModel instance) =>
    <String, dynamic>{
      'raw_text': instance.rawText,
      'merchant_name': instance.merchantName,
      'address': instance.address,
      'date': instance.date,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'category_key': instance.categoryKey,
      'category_name': instance.categoryName,
    };
