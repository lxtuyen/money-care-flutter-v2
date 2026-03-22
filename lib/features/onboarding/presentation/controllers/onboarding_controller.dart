import 'package:get/get.dart';
import 'package:money_care/core/storage/local_storage.dart';

class OnboardingController extends GetxController {
  final LocalStorage storage;

  OnboardingController({required this.storage});

  Future<void> completeOnboarding({required String nextRoute}) async {
    try {
      await storage.saveOnboardingSeen();
      Get.toNamed(nextRoute);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu trạng thái onboarding');
    }
  }
}
