import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

class UserEntity {
  final int id;
  final String email;
  final String role;
  final String? accessToken;
  final UserProfileEntity profile;
  final SavingGoalEntity? savingGoal;
  final bool hasCategories;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.accessToken,
    required this.profile,
    this.savingGoal,
    this.hasCategories = false,
  });

  UserEntity copyWith({
    int? id,
    String? email,
    String? role,
    String? accessToken,
    UserProfileEntity? profile,
    SavingGoalEntity? savingGoal,
    bool? hasCategories,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      profile: profile ?? this.profile,
      savingGoal: savingGoal ?? this.savingGoal,
      hasCategories: hasCategories ?? this.hasCategories,
    );
  }
}
