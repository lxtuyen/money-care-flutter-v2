class PaymentRequestDto {
  final int userId;
  final String platform;
  final double amount;
  final String currency;

  PaymentRequestDto({
    required this.userId,
    required this.platform,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'platform': platform,
      'amount': amount,
      'currency': currency,
    };
  }
}
