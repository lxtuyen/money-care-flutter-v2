import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import '../../data/models/personal_finance_profile_model.dart';
import '../../domain/usecases/get_personal_finance_profile_usecase.dart';

class PersonalizationController extends GetxController {
  final GetPersonalFinanceProfileUseCase useCase;

  PersonalizationController({required this.useCase});

  final Rxn<PersonalFinanceProfileModel> profile = Rxn<PersonalFinanceProfileModel>();
  final RxBool isLoading = false.obs;
  final RxBool isRebuilding = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();

    final appController = Get.find<AppController>();
    ever(appController.userId, (int? userId) {
      if (userId != null) {
        loadProfile();
      } else {
        profile.value = null;
        _clearCache();
      }
    });

    if (appController.userId.value != null) {
      loadProfile();
    }
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await useCase.execute();
      profile.value = res;
      await _saveToCache(res);
    } catch (e) {
      debugPrint('Error loading personalization profile: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rebuildProfile() async {
    isRebuilding.value = true;
    errorMessage.value = '';
    try {
      final res = await useCase.rebuild();
      profile.value = res;
      await _saveToCache(res);
      AppHelperFunction.showSuccessSnackBar('Cập nhật hồ sơ tài chính thành công!');
    } catch (e) {
      debugPrint('Error rebuilding personalization profile: $e');
      AppHelperFunction.showErrorSnackBar('Cập nhật hồ sơ thất bại: $e');
    } finally {
      isRebuilding.value = false;
    }
  }

  void _loadFromCache() {
    try {
      final storage = Get.find<LocalStorage>();
      final cachedStr = storage.readString('personal_finance_profile');
      if (cachedStr != null && cachedStr.isNotEmpty) {
        final Map<String, dynamic> json = jsonDecode(cachedStr);
        profile.value = PersonalFinanceProfileModel.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error loading personalization profile from cache: $e');
    }
  }

  Future<void> _saveToCache(PersonalFinanceProfileModel data) async {
    try {
      final storage = Get.find<LocalStorage>();
      final jsonStr = jsonEncode(data.toJson());
      await storage.writeString('personal_finance_profile', jsonStr);
    } catch (e) {
      debugPrint('Error saving personalization profile to cache: $e');
    }
  }

  Future<void> _clearCache() async {
    try {
      final storage = Get.find<LocalStorage>();
      await storage.remove('personal_finance_profile');
    } catch (e) {
      debugPrint('Error clearing personalization profile cache: $e');
    }
  }
}
