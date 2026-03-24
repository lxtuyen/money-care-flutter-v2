import 'package:get/get.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class LoginOptionController extends GetxController {
  final AuthController authController;

  LoginOptionController({required this.authController});

  RxBool get isLoading => authController.isLoading;

  Future<void> loginWithGoogleAndNavigate() async {
    await authController.loginWithGoogleAndNavigate();
  }
}
