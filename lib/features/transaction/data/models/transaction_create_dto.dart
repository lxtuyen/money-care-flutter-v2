class TransactionCreateDto {
  final int? amount;
  final String? type;
  final String? note;
  final String? pictuteURL;
  final DateTime? transactionDate;
  final int? categoryId;
  final int? userId;

  TransactionCreateDto({
    this.amount,
    this.type,
    this.note,
    this.pictuteURL,
    this.categoryId,
    this.transactionDate,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'note': note,
      'pictuteURL': pictuteURL,
      'categoryId': categoryId,
      'transactionDate': transactionDate?.toIso8601String(),
      'userId': userId,
    };
  }
}
