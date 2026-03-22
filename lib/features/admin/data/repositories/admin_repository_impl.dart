import 'package:money_care/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:money_care/features/admin/domain/entities/entities.dart';
import 'package:money_care/features/admin/domain/repositories/admin_repository.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDatasource remoteDatasource;

  AdminRepositoryImpl({required this.remoteDatasource});

  @override
  Future<UserResponseEntity> updateUser(int userId, UserUpdateDto dto) async {
    final model = await remoteDatasource.updateUser(userId, dto);
    return model.toEntity();
  }

  @override
  Future<AdminUserStatsEntity> getAdminUserStats() async {
    final model = await remoteDatasource.getAdminUserStats();
    return model.toEntity();
  }

  @override
  Future<List<UserResponseEntity>> getListUsers() async {
    final models = await remoteDatasource.getListUsers();
    return models.map((e) => e.toEntity()).toList();
  }
}
