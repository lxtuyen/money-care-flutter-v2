import 'package:get/get.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/splash/presentation/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(storage: Get.find<LocalStorage>()),
      fenix: true,
    );
  }
}
