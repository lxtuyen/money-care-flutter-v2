import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/couple/data/datasources/couple_remote_datasource.dart';
import 'package:money_care/features/couple/data/repositories/couple_repository_impl.dart';
import 'package:money_care/features/couple/domain/repositories/couple_repository.dart';
import 'package:money_care/features/couple/domain/usecases/couple_usecases.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

class CoupleBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();

    Get.lazyPut<CoupleRemoteDatasource>(
      () => CoupleRemoteDatasourceImpl(api: apiClient),
      fenix: true,
    );

    Get.lazyPut<CoupleRepository>(
      () => CoupleRepositoryImpl(
        remoteDatasource: Get.find<CoupleRemoteDatasource>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => GetCoupleInfoUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => CreateCoupleUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => JoinCoupleUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => CancelCoupleInviteUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => LeaveCoupleUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UpdateCoupleSettingsUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCoupleBudgetsUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SetCoupleBudgetUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => DeleteCoupleBudgetUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCoupleSavingGoalsUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => CreateCoupleSavingGoalUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ContributeToCoupleSavingGoalUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => DeleteCoupleSavingGoalUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCoupleSettlementSummaryUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SettleUpCoupleUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SettleUpSingleCoupleUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCoupleReportUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => MarkCoupleAlertReadUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UpdateCoupleAlertUseCase(Get.find<CoupleRepository>()),
      fenix: true,
    );

    Get.lazyPut(
      () => CoupleController(
        getCoupleInfoUseCase: Get.find<GetCoupleInfoUseCase>(),
        createCoupleUseCase: Get.find<CreateCoupleUseCase>(),
        joinCoupleUseCase: Get.find<JoinCoupleUseCase>(),
        cancelCoupleInviteUseCase: Get.find<CancelCoupleInviteUseCase>(),
        leaveCoupleUseCase: Get.find<LeaveCoupleUseCase>(),
        updateCoupleSettingsUseCase: Get.find<UpdateCoupleSettingsUseCase>(),
        getCoupleBudgetsUseCase: Get.find<GetCoupleBudgetsUseCase>(),
        setCoupleBudgetUseCase: Get.find<SetCoupleBudgetUseCase>(),
        deleteCoupleBudgetUseCase: Get.find<DeleteCoupleBudgetUseCase>(),
        getCoupleSavingGoalsUseCase: Get.find<GetCoupleSavingGoalsUseCase>(),
        createCoupleSavingGoalUseCase:
            Get.find<CreateCoupleSavingGoalUseCase>(),
        contributeToCoupleSavingGoalUseCase:
            Get.find<ContributeToCoupleSavingGoalUseCase>(),
        deleteCoupleSavingGoalUseCase:
            Get.find<DeleteCoupleSavingGoalUseCase>(),
        getCoupleSettlementSummaryUseCase:
            Get.find<GetCoupleSettlementSummaryUseCase>(),
        settleUpCoupleUseCase: Get.find<SettleUpCoupleUseCase>(),
        settleUpSingleCoupleUseCase: Get.find<SettleUpSingleCoupleUseCase>(),
        getCoupleReportUseCase: Get.find<GetCoupleReportUseCase>(),
        markCoupleAlertReadUseCase: Get.find<MarkCoupleAlertReadUseCase>(),
        updateCoupleAlertUseCase: Get.find<UpdateCoupleAlertUseCase>(),
      ),
    );
  }
}
