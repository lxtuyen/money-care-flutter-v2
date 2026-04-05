import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class LoginOptionController extends GetxController {
  final AuthController authController;

  LoginOptionController({required this.authController});

  RxBool get isLoading => authController.isLoading;

  Future<void> loginWithGoogleAndNavigate() async {
    final result = await authController.loginWithGoogle();
    result.match(
      (failure) => AppHelperFunction.showErrorSnackBar(failure.message),
      (currentUser) {
        if (currentUser.role == 'user') {
          Get.offAllNamed(
            currentUser.fund != null
                ? RoutePath.main
                : RoutePath.onboardingWelcome,
          );
          return;
        }
        if (currentUser.role == 'admin') {
          Get.offAllNamed(RoutePath.adminHome);
        }
      },
    );
  }
}
