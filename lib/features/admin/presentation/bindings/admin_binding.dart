import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:money_care/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:money_care/features/admin/domain/usecases/admin_usecases.dart';
import 'package:money_care/features/admin/presentation/controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  final ApiClient apiClient;

  AdminBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = AdminRemoteDatasourceImpl(api: apiClient);
    final repository = AdminRepositoryImpl(remoteDatasource: remoteDatasource);

    Get.lazyPut(
      () => AdminController(
        getAdminUserStatsUseCase: GetAdminUserStatsUseCase(repository),
        getListUsersUseCase: GetListUsersUseCase(repository),
        updateUserUseCase: UpdateUserUseCase(repository),
      ),
      fenix: true,
    );
  }
}
