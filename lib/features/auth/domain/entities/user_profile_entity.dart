class UserProfileEntity {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  const UserProfileEntity({
    required this.id,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  String get fullName =>
      '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
