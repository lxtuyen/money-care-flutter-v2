import 'package:get/get.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class OnboardingController extends GetxController {
  final LocalStorage storage;

  OnboardingController({required this.storage});

  Future<void> completeOnboarding({required String nextRoute}) async {
    try {
      await storage.saveOnboardingSeen();
      Get.toNamed(nextRoute);
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(
        'Không thể lưu trạng thái onboarding',
      );
    }
  }
}
