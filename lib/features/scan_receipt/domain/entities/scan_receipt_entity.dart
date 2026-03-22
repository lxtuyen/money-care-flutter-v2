class ScanReceiptEntity {
  final String rawText;
  final String merchantName;
  final String address;
  final String date;
  final int totalAmount;
  final String currency;
  final String categoryKey;
  final String categoryName;

  const ScanReceiptEntity({
    required this.rawText,
    required this.merchantName,
    required this.address,
    required this.date,
    required this.totalAmount,
    required this.currency,
    required this.categoryKey,
    required this.categoryName,
  });
}
