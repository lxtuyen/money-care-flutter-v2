class TransactionCreateDto {
  final int? amount;
  final String? type;
  final String? note;
  final String? pictureUrl;
  final DateTime? transactionDate;
  final int? categoryId;
  final int? userId;
  final int? fundId;

  TransactionCreateDto({
    this.amount,
    this.type,
    this.note,
    this.pictureUrl,
    this.categoryId,
    this.transactionDate,
    this.userId,
    this.fundId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'note': note,
      'pictuteURL': pictureUrl,
      'categoryId': categoryId,
      'transactionDate': transactionDate?.toIso8601String(),
      'userId': userId,
      if (fundId != null) 'fundId': fundId,
    };
  }
}
