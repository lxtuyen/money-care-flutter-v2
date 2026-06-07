import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/user/data/models/profile_update_dto.dart';
import 'package:get/get.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/user/domain/usecases/user_usecase.dart';

class UserController extends GetxController {
  final UpdateMyProfileUseCase updateMyProfileUseCase;

  UserController({required this.updateMyProfileUseCase});

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  Rxn<UserEntity> get user => Get.find<AuthController>().user;

  Worker? _userWorker;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    _userWorker = ever(authController.user, (user) {
      if (user != null) {
        userProfile.value = user.profile;
        _fillControllers(user.profile);
      } else {
        userProfile.value = null;
      }
    });

    if (authController.user.value != null) {
      userProfile.value = authController.user.value!.profile;
      _fillControllers(authController.user.value!.profile);
    }
  }

  void _fillControllers(UserProfileEntity? profile) {
    if (profile == null || isClosed) return;
    firstNameController.text = profile.firstName ?? '';
    lastNameController.text = profile.lastName ?? '';
  }

  var userProfile = Rxn<UserProfileEntity>();
  var isLoading = false.obs;

  Future<bool> updateProfile() async {
    isLoading.value = true;
    try {
      final dto = ProfileUpdateDto(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );
      final result = await updateMyProfileUseCase(dto);
      return result.fold(
        (failure) {
          AppHelperFunction.showErrorSnackBar(failure.message);
          return false;
        },
        (updated) {
          userProfile.value = updated;
          return true;
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void currentProfile(UserProfileEntity profile) {
    userProfile.value = profile;
    _fillControllers(profile);
  }

  @override
  void onClose() {
    _userWorker?.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
