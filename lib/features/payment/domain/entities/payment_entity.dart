class PaymentEntity {
  final int id;
  final int orderCode;
  final int amount;
  final String status;
  final String provider;
  final String? providerTransactionId;
  final DateTime createdAt;
  final DateTime? paidAt;

  const PaymentEntity({
    required this.id,
    required this.orderCode,
    required this.amount,
    required this.status,
    required this.provider,
    this.providerTransactionId,
    required this.createdAt,
    this.paidAt,
  });

  bool get isSuccess => status == 'success';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';

  String get statusLabel {
    switch (status) {
      case 'success':
        return 'Thành công';
      case 'pending':
        return 'Đang xử lý';
      case 'failed':
        return 'Thất bại';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}
