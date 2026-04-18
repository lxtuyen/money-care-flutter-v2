import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class UserEntity {
  final int id;
  final String email;
  final String role;
  final bool isVip;
  final String? accessToken;
  final UserProfileEntity profile;
  final SavingGoalEntity? savingGoal;
  final bool hasCategories;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.isVip = false,
    this.accessToken,
    required this.profile,
    this.savingGoal,
    this.hasCategories = false,
  });

  UserEntity copyWith({
    int? id,
    String? email,
    String? role,
    bool? isVip,
    String? accessToken,
    UserProfileEntity? profile,
    SavingGoalEntity? savingGoal,
    bool? hasCategories,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      isVip: isVip ?? this.isVip,
      accessToken: accessToken ?? this.accessToken,
      profile: profile ?? this.profile,
      savingGoal: savingGoal ?? this.savingGoal,
      hasCategories: hasCategories ?? this.hasCategories,
    );
  }
}
