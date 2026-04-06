import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class ProfileUpdateDto {
  final String? firstName;
  final String? lastName;
  final int? monthlyIncome;
  final DateTime? incomeDate;

  ProfileUpdateDto({
    this.firstName,
    this.lastName,
    this.monthlyIncome,
    this.incomeDate,
  });

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateDto(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      monthlyIncome: json['monthly_income'] as int?,
      incomeDate: json['income_date'] != null
          ? DateTime.parse(json['income_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (monthlyIncome != null) data['monthly_income'] = monthlyIncome;
    if (incomeDate != null) data['income_date'] = incomeDate!.toIso8601String();
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
  final DateTime? incomeDate;

  UserProfileModel({
    this.id,
    required this.firstName,
    required this.lastName,
    this.monthlyIncome,
    this.incomeDate,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] ?? 0,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        monthlyIncome: json['monthly_income'],
        incomeDate: json['income_date'] != null
            ? DateTime.parse(json['income_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'monthly_income': monthlyIncome,
    'income_date': incomeDate?.toIso8601String(),
  };

  UserProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? monthlyIncome,
    DateTime? incomeDate,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      incomeDate: incomeDate ?? this.incomeDate,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    monthlyIncome: monthlyIncome,
    incomeDate: incomeDate,
  );
}
