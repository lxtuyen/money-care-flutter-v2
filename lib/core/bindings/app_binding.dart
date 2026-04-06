import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/services/notification_service.dart';

import 'package:money_care/features/splash/presentation/bindings/splash_binding.dart';
import 'package:money_care/features/auth/presentation/bindings/auth_binding.dart';
import 'package:money_care/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:money_care/features/transaction/presentation/bindings/transaction_binding.dart';
import 'package:money_care/features/fund/presentation/bindings/fund_binding.dart';
import 'package:money_care/features/user/presentation/bindings/user_binding.dart';
import 'package:money_care/features/chatbot/presentation/bindings/chat_binding.dart';
import 'package:money_care/features/admin/presentation/bindings/admin_binding.dart';
import 'package:money_care/features/statistics/presentation/bindings/statistics_binding.dart';
import 'package:money_care/features/notification/presentation/bindings/notification_binding.dart';

import 'package:money_care/features/finance_mode/data/datasources/finance_mode_local_datasource.dart';
import 'package:money_care/features/finance_mode/data/datasources/finance_mode_remote_datasource.dart';
import 'package:money_care/features/finance_mode/data/repositories/finance_mode_repository_impl.dart';
import 'package:money_care/features/finance_mode/domain/usecases/usecases.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';

import 'package:money_care/features/gamification/data/datasources/gamification_remote_datasource.dart';
import 'package:money_care/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:money_care/features/gamification/domain/usecases/usecases.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';

import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

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

    // Register NotificationService synchronously so Get.find works immediately.
    // The async init() runs in the background (FCM token fetch, permissions).
    final notificationService = NotificationService();
    Get.put<NotificationService>(notificationService);
    notificationService.init(); // fire-and-forget; non-blocking

    final appController = AppController(storage: storage);
    Get.put<AppController>(appController);

    // FinanceModeController — singleton for the whole app (Req 5.1–5.5)
    final financeModeLocalDs =
        FinanceModeLocalDatasourceImpl(storage: storage);
    final financeModeRemoteDs =
        FinanceModeRemoteDatasourceImpl(api: apiService);
    final financeModeRepo = FinanceModeRepositoryImpl(
      remoteDatasource: financeModeRemoteDs,
      localDatasource: financeModeLocalDs,
    );
    Get.put<FinanceModeController>(
      FinanceModeController(
        getFinanceModeUseCase: GetFinanceModeUseCase(financeModeRepo),
        switchFinanceModeUseCase: SwitchFinanceModeUseCase(financeModeRepo),
        checkSuggestModeUseCase: CheckSuggestModeUseCase(financeModeRepo),
        repository: financeModeRepo,
        appController: appController,
      ),
      permanent: true,
    );

    // GamificationController — singleton for the whole app
    final gamificationRemoteDs =
        GamificationRemoteDatasourceImpl(api: apiService);
    final gamificationRepo = GamificationRepositoryImpl(
      remoteDatasource: gamificationRemoteDs,
    );
    Get.lazyPut<GamificationController>(
      () => GamificationController(
        getGamificationUseCase: GetGamificationUseCase(gamificationRepo),
        recordDailyTransactionUseCase:
            RecordDailyTransactionUseCase(gamificationRepo),
        checkAndAwardBadgesUseCase:
            CheckAndAwardBadgesUseCase(gamificationRepo),
        notificationService: notificationService,
        appController: appController,
      ),
      fenix: true,
    );

    SplashBinding().dependencies();
    AuthBinding(apiClient: apiService, localStorage: storage).dependencies();
    OnboardingBinding().dependencies();

    Get.put<UserCategoryController>(
      UserCategoryController(apiClient: apiService, appController: appController),
      permanent: true,
    );

    TransactionBinding(apiClient: apiService).dependencies();
    FundBinding(apiClient: apiService).dependencies();
    UserBinding(apiClient: apiService).dependencies();
    ChatBinding(apiClient: apiService).dependencies();
    AdminBinding(apiClient: apiService).dependencies();
    StatisticsBinding(apiClient: apiService).dependencies();
    NotificationBinding(apiClient: apiService).dependencies();
  }
}
