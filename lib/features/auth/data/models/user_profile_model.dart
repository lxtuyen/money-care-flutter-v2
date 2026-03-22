import 'package:money_care/features/auth/domain/entities/user_profile_entity.dart';

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
    id: id ?? 0,
    firstName: firstName,
    lastName: lastName,
  );
}
