class TransactionTotalsDto {
  final int? fundId;
  final String? startDate;
  final String? endDate;
  final String? type;

  TransactionTotalsDto({this.fundId, this.startDate, this.endDate, this.type});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (startDate != null) map['start_date'] = startDate;
    if (endDate != null) map['end_date'] = endDate;
    if (fundId != null) map['fundId'] = fundId;
    if (type != null) map['type'] = type;
    return map;
  }
}
