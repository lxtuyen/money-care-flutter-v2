import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/usecases/usecases.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

class CreateSavingFundController extends GetxController {
  final CreateSavingFundUseCase createSavingFundUseCase;
  final SavingFundController savingFundController =
      Get.find<SavingFundController>();
  final AppController appController = Get.find<AppController>();

  CreateSavingFundController({required this.createSavingFundUseCase});

  RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  Rxn<int> userId = Rxn<int>();
  late final Rx<int> totalPercentage = Rx<int>(0);
  RxBool isLoading = false.obs;
  RxBool isEditMode = false.obs;
  Rxn<int> editingFundId = Rxn<int>();

  final fundNameController = TextEditingController();
  final budgetController = TextEditingController();
  final targetController = TextEditingController();
  Rxn<double> budget = Rxn<double>();
  Rxn<double> target = Rxn<double>();
  Rxn<DateTime> startDate = Rxn<DateTime>();
  Rxn<DateTime> endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    ever(categories, (_) {
      _updateTotalPercentage();
    });
  }

  @override
  void onClose() {
    fundNameController.dispose();
    budgetController.dispose();
    targetController.dispose();
    super.onClose();
  }

  Future<void> initializeCreateFundForm() async {
    await initializeUserInfo();

    final arg = Get.arguments;
    if (arg is SavingFundEntity) {
      isEditMode.value = true;
      editingFundId.value = arg.id;
      fundNameController.text = arg.name;
      budget.value = arg.budget;
      budgetController.text = arg.budget?.toInt().toString() ?? '';
      target.value = arg.target;
      targetController.text = arg.target?.toInt().toString() ?? '';
      startDate.value = arg.start_date;
      endDate.value = arg.end_date;
      categories.assignAll(arg.categories);
    } else {
      isEditMode.value = false;
      editingFundId.value = null;
      _resetForm();
      initializeCategoryDefaults();
      startDate.value = DateTime.now();
    }
  }

  void initializeCategoryDefaults() {
    categories.clear();
    categories.addAll([
      CategoryEntity(icon: 'charity_icon', name: 'Ăn uống', percentage: 0),
      CategoryEntity(icon: 'pleasure_icon', name: 'Mua sắm', percentage: 0),
      CategoryEntity(icon: 'savings_icon', name: 'Di chuyển', percentage: 0),
      CategoryEntity(icon: 'essential_icon', name: 'Hóa đơn', percentage: 0),
      CategoryEntity(
        icon: 'education_icon',
        name: 'Giáo dục',
        percentage: 0,
      ),
      CategoryEntity(icon: 'freedom_icon', name: 'Khác', percentage: 0),
    ]);
    categories.refresh();
  }

  Future<void> initializeUserInfo() async {
    final id = await appController.getCurrentUserId();
    if (id == null) {
      AppHelperFunction.showErrorSnackBar(
        'Không thể xác định người dùng hiện tại',
      );
      return;
    }
    userId.value = id;
  }

  Future<DateTime?> _showStyledDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
  }) {
    return showStyledDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
    );
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await _showStyledDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
    );
    if (picked != null) {
      startDate.value = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await _showStyledDatePicker(
      context: context,
      initialDate:
          endDate.value ??
          (startDate.value?.add(const Duration(days: 30)) ??
              DateTime.now().add(const Duration(days: 30))),
      firstDate: startDate.value ?? DateTime.now(),
    );
    if (picked != null) {
      endDate.value = picked;
    }
  }

  void updateTargetAmount(String value) {
    target.value = double.tryParse(value);
  }

  void updateBudget(String value) {
    budget.value = double.tryParse(value);
  }

  Future<bool> submitCreateFund() async {
    if (userId.value == null) {
      AppHelperFunction.showErrorSnackBar(
        'Không thể xác định người dùng hiện tại',
      );
      return false;
    }

    if (startDate.value == null) {
      AppHelperFunction.showErrorSnackBar(
        'Vui lòng chọn ngày bắt đầu',
      );
      return false;
    }

    if (endDate.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn ngày kết thúc');
      return false;
    }

    if (endDate.value!.isBefore(startDate.value!)) {
      AppHelperFunction.showErrorSnackBar(
        'Ngày kết thúc phải sau ngày bắt đầu',
      );
      return false;
    }

    if (!validatePercentages()) {
      AppHelperFunction.showErrorSnackBar(
        'Tổng phần trăm phải là 100%. Hiện tại là: ${totalPercentage.value}%',
      );
      return false;
    }

    final dto = SavingFundDto(
      categories: categories.toList(),
      name: fundNameController.text.trim(),
      id: isEditMode.value ? editingFundId.value : userId.value,
      budget: budget.value,
      target: target.value,
      start_date: startDate.value,
      end_date: endDate.value,
    );

    if (isEditMode.value) {
      return updateFund(dto);
    }
    return createFund(dto);
  }

  Future<bool> updateFund(SavingFundDto dto) async {
    isLoading.value = true;
    final success = await savingFundController.updateFund(dto);
    if (success) {
      Get.back();
    }
    isLoading.value = false;
    return success;
  }

  void updateCategoryPercentage(int index, int newPercentage) {
    if (index < 0 || index >= categories.length) return;

    final category = categories[index];
    final updatedCategory = CategoryEntity(
      id: category.id,
      name: category.name,
      percentage: newPercentage,
      icon: category.icon,
      color: category.color,
    );

    categories[index] = updatedCategory;
    categories.refresh();
  }

  bool validatePercentages() {
    return totalPercentage.value == 100;
  }

  void _updateTotalPercentage() {
    final sum = categories.fold<int>(0, (sum, cat) => sum + cat.percentage);
    totalPercentage.value = sum;
  }

  Future<bool> createFund(SavingFundDto dto) async {
    isLoading.value = true;
    final result = await createSavingFundUseCase(dto);
    final isSuccess = result.fold(
      (failure) {
        AppHelperFunction.showErrorSnackBar(failure.message);
        return false;
      },
      (fund) {
        savingFundController.savingFunds.add(fund);
        savingFundController.savingFunds.refresh();
        _resetForm();
        AppHelperFunction.showSuccessSnackBar(
          'Tạo quỹ tiết kiệm thành công',
        );
        Get.offNamed(RoutePath.selectSavingFund);
        return true;
      },
    );
    isLoading.value = false;
    return isSuccess;
  }

  void _resetForm() {
    fundNameController.clear();
    budgetController.clear();
    targetController.clear();
    categories.clear();
    totalPercentage.value = 0;
    budget.value = null;
    target.value = null;
    startDate.value = null;
    endDate.value = null;
  }
}




