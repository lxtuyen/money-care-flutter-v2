import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';
import 'package:money_care/features/user/domain/repositories/user_repository.dart';

class UpdateMyProfileUseCase {
  final UserRepository repository;
  UpdateMyProfileUseCase(this.repository);

  Future<UserProfileEntity> call(ProfileUpdateDto dto) {
    return repository.updateMyProfile(dto);
  }
}
