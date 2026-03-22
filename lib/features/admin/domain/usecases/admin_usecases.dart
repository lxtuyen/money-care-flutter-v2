import 'package:money_care/features/admin/domain/entities/entities.dart';
import 'package:money_care/features/admin/domain/repositories/admin_repository.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';

class UpdateUserUseCase {
  final AdminRepository repository;
  UpdateUserUseCase(this.repository);

  Future<UserResponseEntity> call(int userId, UserUpdateDto dto) {
    return repository.updateUser(userId, dto);
  }
}

class GetAdminUserStatsUseCase {
  final AdminRepository repository;
  GetAdminUserStatsUseCase(this.repository);

  Future<AdminUserStatsEntity> call() {
    return repository.getAdminUserStats();
  }
}

class GetListUsersUseCase {
  final AdminRepository repository;
  GetListUsersUseCase(this.repository);

  Future<List<UserResponseEntity>> call() {
    return repository.getListUsers();
  }
}
