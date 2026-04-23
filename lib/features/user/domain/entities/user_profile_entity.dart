class UserProfileEntity {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final int? monthlyIncome;
  final DateTime? incomeDate;

  const UserProfileEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.monthlyIncome,
    this.incomeDate,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
