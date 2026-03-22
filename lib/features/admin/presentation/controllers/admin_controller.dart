import 'package:get/get.dart';
import 'package:money_care/features/admin/domain/entities/entities.dart';
import 'package:money_care/features/admin/domain/usecases/admin_usecases.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';

class AdminController extends GetxController {
  final GetAdminUserStatsUseCase getAdminUserStatsUseCase;
  final GetListUsersUseCase getListUsersUseCase;
  final UpdateUserUseCase updateUserUseCase;

  AdminController({
    required this.getAdminUserStatsUseCase,
    required this.getListUsersUseCase,
    required this.updateUserUseCase,
  });

  final isLoadingStats = false.obs;
  final isUpdatingUser = false.obs;
  final isLoadingUser = false.obs;

  final adminUserStats = Rxn<AdminUserStatsEntity>();
  final listUsers = RxList<UserResponseEntity>();

  final errorMessage = RxnString();

  Future<void> fetchAdminUserStats() async {
    try {
      isLoadingStats.value = true;
      errorMessage.value = null;

      final stats = await getAdminUserStatsUseCase();
      adminUserStats.value = stats;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> fetchListUsers() async {
    try {
      isLoadingUser.value = true;
      errorMessage.value = null;

      final users = await getListUsersUseCase();
      listUsers.value = users;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingUser.value = false;
    }
  }

  Future<void> updateUser(int userId, UserUpdateDto dto) async {
    try {
      isUpdatingUser.value = true;
      errorMessage.value = null;

      final updatedUser = await updateUserUseCase(userId, dto);

      final index = listUsers.indexWhere((u) => u.id == updatedUser.id);
      if (index != -1) {
        listUsers[index] = updatedUser;
        listUsers.refresh();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isUpdatingUser.value = false;
    }
  }
}
