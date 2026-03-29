import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/storage/local_storage.dart';

class SplashController extends GetxController {
  final LocalStorage storage;

  SplashController({required this.storage});

  @override
  void onInit() {
    super.onInit();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    final hasSeenOnboarding = storage.readBool('hasSeenOnboarding') ?? false;
    final hasLoggedIn = storage.readBool('hasLoggedIn') ?? false;
    final hasSeenWelcome = storage.readBool('hasSeenWelcome') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (!hasSeenOnboarding) {
      Get.offAllNamed(RoutePath.onboardingExpenseManagement);
    } else if (!hasLoggedIn) {
      Get.offAllNamed(RoutePath.loginOption);
    } else if (!hasSeenWelcome) {
      Get.offAllNamed(RoutePath.onboardingWelcome);
    } else {
      Get.offAllNamed(RoutePath.main);
    }
  }
}
