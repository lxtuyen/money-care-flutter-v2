class PaymentRequestEntity {
  final int userId;
  final String platform;
  final double amount;
  final String currency;

  const PaymentRequestEntity({
    required this.userId,
    required this.platform,
    required this.amount,
    required this.currency,
  });
}
