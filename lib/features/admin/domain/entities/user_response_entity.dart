class UserResponseEntity {
  final int id;
  final String email;
  final String role;
  final bool isVip;

  const UserResponseEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.isVip,
  });
}
