class TransactionTotalsDto {
  final int? fundId;
  final String? startDate;
  final String? endDate;

  TransactionTotalsDto({this.fundId, this.startDate, this.endDate});

  Map<String, dynamic> toJson() {
    return {'startDate': startDate, 'endDate': endDate, 'fundId': fundId};
  }
}
