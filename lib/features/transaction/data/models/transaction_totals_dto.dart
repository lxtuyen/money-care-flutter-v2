class TransactionTotalsDto {
  final int? fundId;
  final String? startDate;
  final String? endDate;

  TransactionTotalsDto({this.fundId, this.startDate, this.endDate});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (startDate != null) map['start_date'] = startDate;
    if (endDate != null) map['end_date'] = endDate;
    if (fundId != null) map['fundId'] = fundId;
    return map;
  }
}
