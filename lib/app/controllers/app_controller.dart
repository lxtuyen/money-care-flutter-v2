import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';

class AppController extends GetxController {
  final LocalStorage storage;

  AppController({required this.storage});

  var userId = Rxn<int>();
  var isUserInitialized = false.obs;
  var isBalanceVisible = true.obs;
  var isDarkMode = false.obs;
  var currentLocale = 'vi_VN'.obs;
  var startDayOfMonth = 1.obs;
  var isWidgetBalanceVisible = true.obs;
  var errorMessage = RxnString();

  // Premium state
  var isPremium = false.obs;
  var isGracePeriod = false.obs;
  var premiumExpiresAt = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    initializeUser();
    isBalanceVisible.value = storage.getBalanceVisibility();
    isDarkMode.value = storage.getDarkMode();
    currentLocale.value = storage.getLocale();
    startDayOfMonth.value = storage.getStartDayOfMonth();
    isWidgetBalanceVisible.value = storage.getWidgetBalanceVisibility();
    
    // Load Premium state from LocalStorage
    isPremium.value = storage.getIsPremium();
    isGracePeriod.value = storage.getIsGracePeriod();
    premiumExpiresAt.value = storage.getPremiumExpiresAt();
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

  Future<void> updatePremiumStatus({
    required bool isPremium,
    required bool isGracePeriod,
    DateTime? expiresAt,
  }) async {
    this.isPremium.value = isPremium;
    this.isGracePeriod.value = isGracePeriod;
    premiumExpiresAt.value = expiresAt;
    await storage.savePremiumStatus(
      isPremium: isPremium,
      isGracePeriod: isGracePeriod,
      expiresAt: expiresAt,
    );
  }

  void clearUser() {
    userId.value = null;
    isUserInitialized.value = false;
    isPremium.value = false;
    isGracePeriod.value = false;
    premiumExpiresAt.value = null;
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

  void setLocale(String newLocale) {
    currentLocale.value = newLocale;
    storage.saveLocale(newLocale);
    final parts = newLocale.split('_');
    Get.updateLocale(Locale(parts[0], parts[1]));
  }

  Locale get savedLocale {
    final parts = currentLocale.value.split('_');
    return Locale(parts[0], parts[1]);
  }

  void setStartDayOfMonth(int day) {
    startDayOfMonth.value = day;
    storage.saveStartDayOfMonth(day);
  }

  void toggleWidgetBalanceVisibility() {
    isWidgetBalanceVisible.value = !isWidgetBalanceVisible.value;
    storage.saveWidgetBalanceVisibility(isWidgetBalanceVisible.value);

    final statsController = Get.find<StatisticsController>();
    if (userId.value != null) {
      statsController.refreshStatisticsData(userId.value!);
    }
  }
}
