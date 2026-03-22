import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:get/get.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/usecases/saving_fund_usecases.dart';

class SavingFundController extends GetxController {
  final CreateSavingFundUseCase createSavingFundUseCase;
  final GetSavingFundsByUserUseCase getSavingFundsByUserUseCase;
  final GetSavingFundUseCase getSavingFundUseCase;
  final UpdateSavingFundUseCase updateSavingFundUseCase;
  final DeleteSavingFundUseCase deleteSavingFundUseCase;
  final SelectSavingFundUseCase selectSavingFundUseCase;

  SavingFundController({
    required this.createSavingFundUseCase,
    required this.getSavingFundsByUserUseCase,
    required this.getSavingFundUseCase,
    required this.updateSavingFundUseCase,
    required this.deleteSavingFundUseCase,
    required this.selectSavingFundUseCase,
  });

  RxList<SavingFundEntity> savingFunds = <SavingFundEntity>[].obs;
  Rxn<SavingFundEntity> currentFund = Rxn<SavingFundEntity>();
  RxBool isLoadingFunds = false.obs;
  RxBool isLoadingCurrent = false.obs;
  RxString? errorMessage = RxString('');
  var fundId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(fundId, (_) {
      if (fundId.value > 0) {
        loadFundById();
      }
    });
  }

  void updateFundId(int id) {
    fundId.value = id;
  }

  Future<void> loadFunds(int userId) async {
    try {
      isLoadingFunds.value = true;
      final list = await getSavingFundsByUserUseCase(userId);
      savingFunds.assignAll(list);
    } catch (e) {
      errorMessage?.value = e.toString();
    } finally {
      isLoadingFunds.value = false;
    }
  }

  Future<void> loadFundById() async {
    try {
      isLoadingCurrent.value = true;
      currentFund.value = await getSavingFundUseCase(fundId.value);
    } catch (e) {
      errorMessage?.value = e.toString();
    } finally {
      isLoadingCurrent.value = false;
    }
  }

  Future<void> selectSavingFund(int userId, int id) async {
    try {
      isLoadingCurrent.value = true;

      final selected = await selectSavingFundUseCase(userId, id);
      fundId.value = id;

      loadFunds(userId); // Reload list to update isSelected status

      currentFund.value = selected;
    } catch (e) {
      errorMessage?.value = e.toString();
    } finally {
      isLoadingCurrent.value = false;
    }
  }

  Future<void> createFund(SavingFundDto dto) async {
    try {
      final fund = await createSavingFundUseCase(dto);
      savingFunds.add(fund);
      savingFunds.refresh();
    } catch (e) {
      errorMessage?.value = e.toString();
    }
  }

  Future<void> updateFund(SavingFundDto dto) async {
    try {
      final updated = await updateSavingFundUseCase(dto);

      final index = savingFunds.indexWhere((f) => f.id == dto.id);
      if (index != -1) {
        savingFunds[index] = updated;
        savingFunds.refresh();
      }

      if (currentFund.value?.id == dto.id) {
        currentFund.value = updated;
      }
    } catch (e) {
      errorMessage?.value = e.toString();
    }
  }

  Future<void> deleteFund(int id) async {
    try {
      final ok = await deleteSavingFundUseCase(id);
      if (ok) {
        savingFunds.removeWhere((f) => f.id == id);
        savingFunds.refresh();

        if (currentFund.value?.id == id) {
          currentFund.value = null;
          fundId.value = 0;
        }
      }
    } catch (e) {
      errorMessage?.value = e.toString();
    }
  }

  int get currentFundId => fundId.value;

  SavingFundEntity? get selectedFund => currentFund.value;
}
