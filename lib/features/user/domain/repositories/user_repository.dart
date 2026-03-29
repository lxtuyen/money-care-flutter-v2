import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<UserProfileEntity> updateMyProfile(ProfileUpdateDto dto);
}
