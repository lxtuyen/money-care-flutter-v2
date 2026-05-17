import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/services/notification_service.dart';

import 'package:money_care/app/bindings/app_state_binding.dart';
import 'package:money_care/core/services/ocr_service.dart';

import 'package:money_care/features/splash/presentation/bindings/splash_binding.dart';
import 'package:money_care/features/auth/presentation/bindings/auth_binding.dart';
import 'package:money_care/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:money_care/features/transaction/presentation/bindings/transaction_binding.dart';
import 'package:money_care/features/saving_goal/presentation/bindings/saving_goal_binding.dart';
import 'package:money_care/features/user/presentation/bindings/user_binding.dart';
import 'package:money_care/features/chatbot/presentation/bindings/chat_binding.dart';
import 'package:money_care/features/notification/presentation/bindings/notification_binding.dart';
import 'package:money_care/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:money_care/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';

import 'package:money_care/features/gamification/data/datasources/gamification_remote_datasource.dart';
import 'package:money_care/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:money_care/features/gamification/domain/usecases/usecases.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';

import 'package:money_care/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/create_transaction_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/filter_transactions_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:money_care/features/transaction/domain/usecases/export_report_usecase.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/data/datasources/recurring_transaction_remote_datasource.dart';
import 'package:money_care/features/transaction/data/repositories/recurring_transaction_repository_impl.dart';
import 'package:money_care/features/transaction/domain/usecases/recurring_transaction_usecases.dart';
import 'package:money_care/features/transaction/presentation/controllers/recurring_transaction_controller.dart';

import 'package:money_care/features/saving_goal/data/datasources/saving_goal_remote_datasource.dart';
import 'package:money_care/features/saving_goal/data/repositories/saving_goal_repository_impl.dart';
import 'package:money_care/features/saving_goal/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';

import 'package:money_care/features/user/data/datasources/user_remote_datasource.dart';
import 'package:money_care/features/user/data/repositories/user_repository_impl.dart';
import 'package:money_care/features/user/domain/usecases/user_usecase.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/features/home/presentation/controllers/home_controller.dart';
import 'package:money_care/features/spending_plan/data/datasources/spending_plan_remote_datasource.dart';
import 'package:money_care/features/spending_plan/data/repositories/spending_plan_repository_impl.dart';
import 'package:money_care/features/spending_plan/domain/usecases/usecases.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';

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

    final notificationService = NotificationService();
    Get.put<NotificationService>(notificationService);
    notificationService.init();

    final appController = AppController(storage: storage);
    Get.put<AppController>(appController);

    final gamificationRemoteDs = GamificationRemoteDatasourceImpl(
      api: apiService,
    );
    final gamificationRepo = GamificationRepositoryImpl(
      remoteDatasource: gamificationRemoteDs,
    );
    Get.lazyPut<GamificationController>(
      () => GamificationController(
        getGamificationUseCase: GetGamificationUseCase(gamificationRepo),
        recordDailyTransactionUseCase: RecordDailyTransactionUseCase(
          gamificationRepo,
        ),
        checkAndAwardBadgesUseCase: CheckAndAwardBadgesUseCase(
          gamificationRepo,
        ),
        notificationService: notificationService,
        appController: appController,
      ),
      fenix: true,
    );

    SplashBinding().dependencies();
    AuthBinding().dependencies();
    OnboardingBinding().dependencies();

    Get.put<UserCategoryController>(
      UserCategoryController(
        apiClient: apiService,
        appController: appController,
      ),
      permanent: true,
    );

    final savingGoalRemoteDs = SavingGoalRemoteDatasourceImpl(api: apiService);
    final savingGoalRepo = SavingGoalRepositoryImpl(
      remoteDatasource: savingGoalRemoteDs,
    );
    Get.put<SavingGoalController>(
      SavingGoalController(
        getSavingGoalsByUserUseCase: GetSavingGoalsByUserUseCase(
          savingGoalRepo,
        ),
        getSavingGoalUseCase: GetSavingGoalUseCase(savingGoalRepo),
        updateSavingGoalUseCase: UpdateSavingGoalUseCase(savingGoalRepo),
        deleteSavingGoalUseCase: DeleteSavingGoalUseCase(savingGoalRepo),
        selectSavingGoalUseCase: SelectSavingGoalUseCase(savingGoalRepo),
        checkExpiredSavingGoalUseCase: CheckExpiredSavingGoalUseCase(
          savingGoalRepo,
        ),
        markAsNotifiedUseCase: MarkAsNotifiedUseCase(savingGoalRepo),
        extendSavingGoalUseCase: ExtendSavingGoalUseCase(savingGoalRepo),
        getSavingGoalReportUseCase: GetSavingGoalReportUseCase(savingGoalRepo),
      ),
      permanent: true,
    );

    final transactionRemoteDs = TransactionRemoteDatasourceImpl(
      api: apiService,
    );
    final ocrService = Get.put(OCRService());
    final transactionRepo = TransactionRepositoryImpl(
      remoteDatasource: transactionRemoteDs,
      ocrService: ocrService,
    );
    Get.put<TransactionController>(
      TransactionController(
        filterTransactionsUseCase: FilterTransactionsUseCase(transactionRepo),
        createTransactionUseCase: CreateTransactionUseCase(transactionRepo),
        updateTransactionUseCase: UpdateTransactionUseCase(transactionRepo),
        deleteTransactionUseCase: DeleteTransactionUseCase(transactionRepo),
        exportReportUseCase: ExportReportUseCase(transactionRepo),
      ),
      permanent: true,
    );

    final recurringRemoteDs = RecurringTransactionRemoteDataSourceImpl(
      api: apiService,
    );
    final recurringRepo = RecurringTransactionRepositoryImpl(
      remoteDataSource: recurringRemoteDs,
    );
    Get.put<RecurringTransactionController>(
      RecurringTransactionController(
        getRecurringTransactionsUseCase: GetRecurringTransactionsUseCase(
          recurringRepo,
        ),
        createRecurringTransactionUseCase: CreateRecurringTransactionUseCase(
          recurringRepo,
        ),
        deleteRecurringTransactionUseCase: DeleteRecurringTransactionUseCase(
          recurringRepo,
        ),
      ),
      permanent: true,
    );

    final walletRemoteDs = WalletRemoteDatasourceImpl(api: apiService);
    final walletRepo = WalletRepositoryImpl(remoteDatasource: walletRemoteDs);
    Get.put<WalletController>(
      WalletController(repository: walletRepo),
      permanent: true,
    );

    final spendingPlanRemoteDs = SpendingPlanRemoteDatasourceImpl(
      api: apiService,
    );
    final spendingPlanRepo = SpendingPlanRepositoryImpl(
      remoteDatasource: spendingPlanRemoteDs,
    );
    Get.put<SpendingPlanController>(
      SpendingPlanController(
        getSpendingPlansUseCase: GetSpendingPlansUseCase(spendingPlanRepo),
        getActiveSpendingPlanUseCase: GetActiveSpendingPlanUseCase(
          spendingPlanRepo,
        ),
        getSpendingPlanUseCase: GetSpendingPlanUseCase(spendingPlanRepo),
        createSpendingPlanUseCase: CreateSpendingPlanUseCase(spendingPlanRepo),
        updateSpendingPlanUseCase: UpdateSpendingPlanUseCase(spendingPlanRepo),
        deleteSpendingPlanUseCase: DeleteSpendingPlanUseCase(spendingPlanRepo),
        activateSpendingPlanUseCase: ActivateSpendingPlanUseCase(
          spendingPlanRepo,
        ),
        archiveSpendingPlanUseCase: ArchiveSpendingPlanUseCase(
          spendingPlanRepo,
        ),
      ),
      permanent: true,
    );

    final userRemoteDs = UserRemoteDatasourceImpl(api: apiService);
    final userRepo = UserRepositoryImpl(remoteDatasource: userRemoteDs);
    Get.put<UserController>(
      UserController(updateMyProfileUseCase: UpdateMyProfileUseCase(userRepo)),
      permanent: true,
    );

    AppStateBinding(apiClient: apiService).dependencies();
    Get.put<HomeController>(HomeController());

    TransactionBinding().dependencies();
    SavingGoalBinding().dependencies();
    UserBinding().dependencies();
    ChatBinding().dependencies();
    NotificationBinding().dependencies();
  }
}
