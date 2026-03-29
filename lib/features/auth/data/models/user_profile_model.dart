import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String? avatar;

  UserProfileModel({
    this.id,
    required this.firstName,
    required this.lastName,
    this.avatar,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] ?? 0,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        avatar: json['avatar'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'avatar': avatar,
  };

  UserProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? avatar,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
    id: id ?? 0,
    firstName: firstName,
    lastName: lastName,
    avatar: avatar,
  );
}
