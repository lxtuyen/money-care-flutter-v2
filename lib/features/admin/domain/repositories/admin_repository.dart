import 'package:money_care/features/admin/domain/entities/entities.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';

abstract class AdminRepository {
  Future<UserResponseEntity> updateUser(int userId, UserUpdateDto dto);
  Future<AdminUserStatsEntity> getAdminUserStats();
  Future<List<UserResponseEntity>> getListUsers();
}
