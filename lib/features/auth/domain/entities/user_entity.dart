import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class UserEntity {
  final int id;
  final String email;
  final String role;
  final bool? isVip;
  final String? accessToken;
  final UserProfileEntity profile;
  final FundEntity? fund;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.isVip,
    this.accessToken,
    required this.profile,
    this.fund,
  });

  UserEntity copyWith({String? accessToken}) {
    return UserEntity(
      id: id,
      email: email,
      role: role,
      isVip: isVip,
      accessToken: accessToken ?? this.accessToken,
      profile: profile,
      fund: fund,
    );
  }
}
