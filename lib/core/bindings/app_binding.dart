import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/controllers/app_controller.dart';

import 'package:money_care/features/splash/presentation/bindings/splash_binding.dart';
import 'package:money_care/features/auth/presentation/bindings/auth_binding.dart';
import 'package:money_care/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:money_care/features/transaction/presentation/bindings/transaction_binding.dart';
import 'package:money_care/features/saving_fund/presentation/bindings/saving_fund_binding.dart';
import 'package:money_care/features/user/presentation/bindings/user_binding.dart';
import 'package:money_care/features/chatbot/presentation/bindings/chat_binding.dart';
import 'package:money_care/features/admin/presentation/bindings/admin_binding.dart';
import 'package:money_care/features/statistics/presentation/bindings/statistics_binding.dart';

class AppBinding extends Bindings {
  final LocalStorage storage;

  AppBinding({required this.storage});

  @override
  void dependencies() {
    final apiService = ApiClient(
      baseUrl: dotenv.env[kIsWeb ? 'API_LOCALHOST_URL' : 'API_BASE_URL'] ?? '',
    );

    Get.put<ApiClient>(apiService);
    Get.put<LocalStorage>(storage);

    Get.put<AppController>(AppController(storage: storage));

    SplashBinding().dependencies();
    AuthBinding(apiClient: apiService, localStorage: storage).dependencies();
    OnboardingBinding().dependencies();
    TransactionBinding(apiClient: apiService).dependencies();
    SavingFundBinding(apiClient: apiService).dependencies();
    UserBinding(apiClient: apiService).dependencies();
    ChatBinding(apiClient: apiService).dependencies();
    AdminBinding(apiClient: apiService).dependencies();
    StatisticsBinding(apiClient: apiService).dependencies();
  }
}
