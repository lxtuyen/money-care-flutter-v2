import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import '../../domain/repositories/personalization_repository.dart';
import '../../data/repositories/personalization_repository_impl.dart';
import '../../domain/usecases/get_personal_finance_profile_usecase.dart';
import '../controllers/personalization_controller.dart';

class PersonalizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalizationRepository>(
      () => PersonalizationRepositoryImpl(api: Get.find<ApiClient>()),
    );
    Get.lazyPut<GetPersonalFinanceProfileUseCase>(
      () => GetPersonalFinanceProfileUseCase(Get.find<PersonalizationRepository>()),
    );
    Get.lazyPut<PersonalizationController>(
      () => PersonalizationController(useCase: Get.find<GetPersonalFinanceProfileUseCase>()),
    );
  }
}
