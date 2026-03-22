import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/admin/data/models/models.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';

abstract class AdminRemoteDatasource {
  Future<UserResponseModel> updateUser(int userId, UserUpdateDto dto);
  Future<AdminUserStatsModel> getAdminUserStats();
  Future<List<UserResponseModel>> getListUsers();
}

class AdminRemoteDatasourceImpl implements AdminRemoteDatasource {
  final ApiClient api;

  AdminRemoteDatasourceImpl({required this.api});

  @override
  Future<UserResponseModel> updateUser(int userId, UserUpdateDto dto) async {
    final res = await api.patch<UserResponseModel>(
      '${ApiRoutes.users}/$userId',
      body: dto.toJson(),
      fromJsonT: (json) => UserResponseModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<AdminUserStatsModel> getAdminUserStats() async {
    final res = await api.get<AdminUserStatsModel>(
      ApiRoutes.stats,
      fromJsonT: (json) => AdminUserStatsModel.fromJson(json),
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }

  @override
  Future<List<UserResponseModel>> getListUsers() async {
    final res = await api.get<List<UserResponseModel>>(
      ApiRoutes.users,
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list.map((e) => UserResponseModel.fromJson(e)).toList();
      },
    );
    if (!res.success || res.data == null) throw Exception(res.message);
    return res.data!;
  }
}
