import 'package:money_care/features/auth/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/auth/domain/entities/user_profile_entity.dart';

class UserEntity {
  final int id;
  final String email;
  final String role;
  final bool? isVip;
  final String? accessToken;
  final UserProfileEntity profile;
  final SavingFundEntity? savingFund;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.isVip,
    this.accessToken,
    required this.profile,
    this.savingFund,
  });

  UserEntity copyWith({String? accessToken}) {
    return UserEntity(
      id: id,
      email: email,
      role: role,
      isVip: isVip,
      accessToken: accessToken ?? this.accessToken,
      profile: profile,
      savingFund: savingFund,
    );
  }
}
