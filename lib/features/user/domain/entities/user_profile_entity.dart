class UserProfileEntity {
  final int? id;
  final String firstName;
  final String lastName;
  final int? monthlyIncome;

  const UserProfileEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    this.monthlyIncome,
  });

  String get fullName => '$firstName $lastName';
}
