import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class ProfileUpdateDto {
  final String? firstName;
  final String? lastName;
  final int? monthlyIncome;

  ProfileUpdateDto({
    this.firstName,
    this.lastName,
    this.monthlyIncome,
  });

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateDto(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      monthlyIncome: json['monthly_income'] == null
          ? null
          : int.tryParse(json['monthly_income'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (monthlyIncome != null) data['monthly_income'] = monthlyIncome;
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
  final int? monthlyIncome;

  UserProfileModel({
    this.id,
    required this.firstName,
    required this.lastName,
    this.monthlyIncome,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] ?? 0,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        monthlyIncome: json['monthly_income'] != null
            ? double.tryParse(json['monthly_income'].toString())?.toInt()
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'monthly_income': monthlyIncome,
  };

  UserProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? monthlyIncome,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    monthlyIncome: monthlyIncome,
  );
}
