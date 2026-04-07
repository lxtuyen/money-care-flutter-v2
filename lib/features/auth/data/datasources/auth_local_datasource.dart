import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final LocalStorage storage;
  AuthLocalDatasourceImpl({required this.storage});

  @override
  Future<void> cacheUser(UserModel user) async {
    if (user.accessToken != null) {
      await storage.saveToken(user.accessToken!);
    }
    await storage.saveUserInfo(user.toJson());
  }

  @override
  UserModel? getCachedUser() {
    final json = storage.getUserInfo();
    if (json == null) return null;
    final token = storage.getToken();
    try {
      return UserModel.fromAuthJson(json, token);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await storage.logout();
  }
}
