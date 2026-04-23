import 'package:flutter/material.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:money_care/features/user/data/models/profile_update_dto.dart';
import 'package:money_care/features/user/data/models/user_update_dto.dart';
import 'package:get/get.dart';
import 'package:money_care/features/user/domain/entities/user_profile_entity.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/user/domain/usecases/user_usecase.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/utils/date_picker_util.dart';

class UserController extends GetxController {
  final UpdateMyProfileUseCase updateMyProfileUseCase;

  UserController({required this.updateMyProfileUseCase});

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController monthlyIncomeController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  final Rx<DateTime?> incomeDate = Rx(null);

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
    monthlyIncomeController.text = profile.monthlyIncome != null
        ? profile.monthlyIncome.toString()
        : '';
    incomeDate.value = profile.incomeDate;
    avatarController.text = profile.avatar ?? '';
  }

  var userProfile = Rxn<UserProfileEntity>();
  var isLoading = false.obs;

  Future<void> pickIncomeDay(BuildContext context) async {
    final pickedDay = await pickDayOfMonth(
      context,
      initialDay: incomeDate.value?.day,
    );
    if (pickedDay != null) {
      final now = DateTime.now();
      incomeDate.value = DateTime(now.year, now.month, pickedDay);
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final dto = ProfileUpdateDto(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        monthlyIncome: int.tryParse(
          AppHelperFunction.unformatCurrency(monthlyIncomeController.text),
        ),
        incomeDate: incomeDate.value,
        avatar: avatarController.text.trim(),
      );
      final updated = await updateMyProfileUseCase(dto);
      userProfile.value = updated;

      // Trigger balance suggestion = floor(monthlyIncome * 0.9) (Req 2.2)
      if (updated.monthlyIncome != null && updated.monthlyIncome! > 0) {
        _triggerBudgetSuggestion(updated.monthlyIncome!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _triggerBudgetSuggestion(int monthlyIncome) {
    final suggestedAmount = (monthlyIncome * 0.9).floor();
    // TODO: Implement actual budget suggestion logic (e.g., calling BudgetController)
    debugPrint('Suggested monthly budget: $suggestedAmount');
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
    monthlyIncomeController.dispose();
    super.onClose();
  }
}
