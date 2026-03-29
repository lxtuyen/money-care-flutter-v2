import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:get/get.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/user/domain/usecases/user_usecase.dart';

class UserController extends GetxController {
  final UpdateMyProfileUseCase updateMyProfileUseCase;

  UserController({
    required this.updateMyProfileUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    ever(authController.user, (user) {
      if (user != null) {
        userProfile.value = user.profile;
      } else {
        userProfile.value = null;
      }
    });

    if (authController.user.value != null) {
      userProfile.value = authController.user.value!.profile;
    }
  }

  var userProfile = Rxn<UserProfileEntity>();
  var isLoading = false.obs;

  Future<void> updateProfile(ProfileUpdateDto dto) async {
    try {
      isLoading.value = true;
      final updated = await updateMyProfileUseCase(dto);
      userProfile.value = updated;
    } finally {
      isLoading.value = false;
    }
  }

  void currentProfile(UserProfileEntity profile) {
    userProfile.value = profile;
  }
}
