import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/user/data/datasources/user_remote_datasource.dart';
import 'package:money_care/features/user/data/repositories/user_repository_impl.dart';
import 'package:money_care/features/personalization/domain/repositories/personalization_repository.dart';
import 'package:money_care/features/personalization/data/repositories/personalization_repository_impl.dart';
import 'package:money_care/features/personalization/domain/usecases/get_personal_finance_profile_usecase.dart';
import 'package:money_care/features/personalization/presentation/controllers/personalization_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final remoteDatasource = UserRemoteDatasourceImpl(api: apiClient);
    UserRepositoryImpl(remoteDatasource: remoteDatasource);

    Get.lazyPut<PersonalizationRepository>(
      () => PersonalizationRepositoryImpl(api: apiClient),
      fenix: true,
    );
    Get.lazyPut<GetPersonalFinanceProfileUseCase>(
      () => GetPersonalFinanceProfileUseCase(Get.find<PersonalizationRepository>()),
      fenix: true,
    );
    if (!Get.isRegistered<PersonalizationController>()) {
      Get.put<PersonalizationController>(
        PersonalizationController(useCase: Get.find<GetPersonalFinanceProfileUseCase>()),
        permanent: true,
      );
    }
  }
}
