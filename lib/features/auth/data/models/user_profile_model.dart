import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final int? id;
  final String firstName;
  final String lastName;
  final int? monthlyIncome;
  final String? avatar;

  UserProfileModel({
    this.id,
    required this.firstName,
    required this.lastName,
    this.monthlyIncome,
    this.avatar,
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
        avatar: json['avatar'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'monthly_income': monthlyIncome,
    'avatar': avatar,
  };

  UserProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? monthlyIncome,
    String? avatar,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      avatar: avatar ?? this.avatar,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
    id: id ?? 0,
    firstName: firstName,
    lastName: lastName,
    monthlyIncome: monthlyIncome,
    avatar: avatar,
  );
}
