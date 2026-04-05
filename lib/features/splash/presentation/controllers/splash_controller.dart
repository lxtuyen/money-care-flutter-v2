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
    await Future.delayed(const Duration(seconds: 2));

    final hasLoggedIn = storage.readBool('hasLoggedIn') ?? false;

    if (!hasLoggedIn) {
      Get.offAllNamed(RoutePath.loginOption);
    } else {
      Get.offAllNamed(RoutePath.main);
    }
  }
}
