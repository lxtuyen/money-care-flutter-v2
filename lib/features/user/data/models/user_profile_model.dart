import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class ProfileUpdateDto {
  final String? firstName;
  final String? lastName;
  ProfileUpdateDto({
    this.firstName,
    this.lastName,
  });

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateDto(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    return data;
  }
}

class UserUpdateDto {
  final String? role;
  final bool? isVip;

  UserUpdateDto({this.role, this.isVip});

  Map<String, dynamic> toJson() {
    return {'role': role, 'isVip': isVip};
  }
}

class UserProfileModel {
  final int? id;
  final String firstName;
  final String lastName;
  UserProfileModel({
    this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] ?? 0,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
  };

  UserProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
  );
}
