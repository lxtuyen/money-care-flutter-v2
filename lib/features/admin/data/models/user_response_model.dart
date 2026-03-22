import 'package:money_care/features/admin/domain/entities/entities.dart';

class UserResponseModel {
  final int id;
  final String email;
  final String role;
  final bool isVip;

  UserResponseModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isVip,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        id: json['id'],
        email: json['email'],
        role: json['role'],
        isVip: json['isVip'],
      );

  UserResponseEntity toEntity() =>
      UserResponseEntity(id: id, email: email, role: role, isVip: isVip);
}
