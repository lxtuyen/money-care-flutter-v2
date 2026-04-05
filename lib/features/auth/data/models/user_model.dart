import 'package:money_care/features/auth/data/models/fund_model.dart';
import 'package:money_care/features/auth/data/models/user_profile_model.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';

export 'fund_model.dart';
export 'user_profile_model.dart';

class UserModel {
  final int id;
  final String email;
  final String role;
  final bool? isVip;
  final String? accessToken;
  final UserProfileModel profile;
  final FundModel? fund;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.isVip,
    required this.profile,
    this.accessToken,
    this.fund,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String? token) =>
      UserModel(
        id: json['id'],
        email: json['email'],
        role: json['role'],
        isVip: json['isVip'],
        accessToken: token,
        profile: UserProfileModel.fromJson(json['profile']),
        fund: json['fund'] != null
            ? FundModel.fromMap(json['fund'])
            : null,
      );

  factory UserModel.fromJsonUpdate(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    role: json['role'],
    isVip: json['isVip'],
    profile: UserProfileModel.fromJson(json['profile']),
    fund: json['fund'] != null
        ? FundModel.fromMap(json['fund'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'role': role,
    'isVip': isVip,
    'accessToken': accessToken,
    'profile': profile.toJson(),
    'fund': fund?.toMap(),
  };

  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    role: role,
    isVip: isVip,
    accessToken: accessToken,
    profile: profile.toEntity(),
    fund: fund?.toEntity(),
  );
}
