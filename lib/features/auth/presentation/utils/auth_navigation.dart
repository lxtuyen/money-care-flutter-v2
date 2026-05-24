import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';

class AuthNavigation {
  const AuthNavigation._();

  static void goAfterLogin(UserEntity currentUser) {
    if (currentUser.role == 'admin') {
      Get.offAllNamed(RoutePath.adminHome);
      return;
    }

    if (currentUser.role != 'user') {
      Get.offAllNamed(RoutePath.loginOption);
      return;
    }

    if (currentUser.shouldRunInitialFinancialSetup) {
      Get.offAllNamed(RoutePath.onboardingWelcome);
      return;
    }

    Get.offAllNamed(RoutePath.main);
  }
}
