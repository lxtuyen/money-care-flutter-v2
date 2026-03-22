class TransactionFilterDto {
  final int? categoryId;
  final int? fundId;
  final String? startDate;
  final String? endDate;

  TransactionFilterDto({
    this.categoryId,
    this.fundId,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toQueryParams() {
    final map = <String, dynamic>{};
    if (categoryId != null) map['categoryId'] = categoryId;
    if (fundId != null) map['fundId'] = fundId;
    if (startDate != null) map['start_date'] = startDate;
    if (endDate != null) map['end_date'] = endDate;
    return map;
  }
}
