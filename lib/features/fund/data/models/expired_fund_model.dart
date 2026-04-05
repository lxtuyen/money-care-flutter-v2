class ExpiredFundInfoModel {
  final int id;
  final String name;
  final DateTime? endDate;
  final int completionPercentage;
  final double totalSpent;
  final double target;
  final double balance;

  ExpiredFundInfoModel({
    required this.id,
    required this.name,
    this.endDate,
    required this.completionPercentage,
    required this.totalSpent,
    required this.target,
    required this.balance,
  });

  factory ExpiredFundInfoModel.fromMap(Map<String, dynamic> json) {
    return ExpiredFundInfoModel(
      id: json['id'],
      name: json['name'],
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      completionPercentage: json['completion_percentage'] ?? 0,
      totalSpent: double.tryParse(json['total_spent'].toString()) ?? 0,
      target: double.tryParse(json['target'].toString()) ?? 0,
      balance: double.tryParse(json['balance'].toString()) ?? 0,
    );
  }
}

class ExpiredFundCheckModel {
  final bool hasExpiredFund;
  final ExpiredFundInfoModel? expiredFund;

  ExpiredFundCheckModel({
    required this.hasExpiredFund,
    this.expiredFund,
  });

  factory ExpiredFundCheckModel.fromMap(Map<String, dynamic> json) {
    return ExpiredFundCheckModel(
      hasExpiredFund: json['has_expired_fund'] ?? false,
      expiredFund: json['expired_fund'] != null
          ? ExpiredFundInfoModel.fromMap(json['expired_fund'])
          : null,
    );
  }
}
