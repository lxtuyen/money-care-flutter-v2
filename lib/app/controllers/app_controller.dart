import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';

class AppController extends GetxController {
  final LocalStorage storage;

  AppController({required this.storage});

  var userId = Rxn<int>();
  var isUserInitialized = false.obs;
  var isBalanceVisible = true.obs;
  var isDarkMode = false.obs;
  var currentLocale = 'vi_VN'.obs;
  var errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    initializeUser();
    isBalanceVisible.value = storage.getBalanceVisibility();
    isDarkMode.value = storage.getDarkMode();
    currentLocale.value = storage.getLocale();
  }

  Future<void> initializeUser() async {
    try {
      final userInfoJson = storage.getUserInfo();
      if (userInfoJson == null) {
        userId.value = null;
        isUserInitialized.value = true;
        return;
      }

      final user = UserModel.fromJson(userInfoJson);
      userId.value = user.id;
      isUserInitialized.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
      isUserInitialized.value = true;
    }
  }

  void setUserId(int? id) {
    userId.value = id;
    if (id != null) {
      isUserInitialized.value = true;
    }
  }

  void clearUser() {
    userId.value = null;
    isUserInitialized.value = false;
  }

  Future<int?> getCurrentUserId() async {
    if (!isUserInitialized.value) {
      await initializeUser();
    }
    return userId.value;
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
    storage.saveBalanceVisibility(isBalanceVisible.value);
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    storage.saveDarkMode(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleLocale() {
    final newLocale = currentLocale.value == 'vi_VN' ? 'en_US' : 'vi_VN';
    currentLocale.value = newLocale;
    storage.saveLocale(newLocale);
    final parts = newLocale.split('_');
    Get.updateLocale(Locale(parts[0], parts[1]));
  }

  Locale get savedLocale {
    final parts = currentLocale.value.split('_');
    return Locale(parts[0], parts[1]);
  }
}
