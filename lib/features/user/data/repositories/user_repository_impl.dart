import 'package:money_care/features/user/data/datasources/user_remote_datasource.dart';
import 'package:money_care/features/user/data/models/profile_update_dto.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';
import 'package:money_care/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<UserProfileEntity> updateMyProfile(ProfileUpdateDto dto) async {
    final model = await remoteDatasource.updateMyProfile(dto);
    return model.toEntity();
  }
}
