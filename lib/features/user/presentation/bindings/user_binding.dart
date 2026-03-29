import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/user/data/datasources/user_remote_datasource.dart';
import 'package:money_care/features/user/data/repositories/user_repository_impl.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/features/user/domain/usecases/user_usecase.dart';


class UserBinding extends Bindings {
  final ApiClient apiClient;

  UserBinding({required this.apiClient});

  @override
  void dependencies() {
    final remoteDatasource = UserRemoteDatasourceImpl(api: apiClient);
    final repository = UserRepositoryImpl(remoteDatasource: remoteDatasource);

    Get.lazyPut(
      () => UserController(
        updateMyProfileUseCase: UpdateMyProfileUseCase(repository),
      ),
      fenix: true,
    );
  }
}
