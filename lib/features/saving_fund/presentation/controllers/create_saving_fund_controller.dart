import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/usecases/usecases.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';

class CreateSavingFundController extends GetxController {
  final CreateSavingFundUseCase createSavingFundUseCase;
  final SavingFundController savingFundController =
      Get.find<SavingFundController>();

  CreateSavingFundController({required this.createSavingFundUseCase});

  RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  Rxn<int> userId = Rxn<int>();
  late final Rx<int> totalPercentage = Rx<int>(0);
  RxBool isLoading = false.obs;
  RxBool isEditMode = false.obs;
  Rxn<int> editingFundId = Rxn<int>();

  final fundNameController = TextEditingController();
  final targetAmountController = TextEditingController();
  Rxn<double> targetAmount = Rxn<double>();
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
    targetAmountController.dispose();
    super.onClose();
  }

  Future<void> initializeCreateFundForm() async {
    await initializeUserInfo();

    final arg = Get.arguments;
    if (arg is SavingFundEntity) {
      isEditMode.value = true;
      editingFundId.value = arg.id;
      fundNameController.text = arg.name;
      targetAmount.value = arg.amount;
      targetAmountController.text = arg.amount?.toInt().toString() ?? '';
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
      CategoryEntity(icon: 'education_icon', name: 'Giáo dục', percentage: 0),
      CategoryEntity(icon: 'freedom_icon', name: 'Khác', percentage: 0),
    ]);
    categories.refresh();
  }

  Future<void> initializeUserInfo() async {
    final userInfoJson = LocalStorage().getUserInfo();
    if (userInfoJson == null) {
      AppHelperFunction.showSnackBar('Không thể xác định người dùng hiện tại');
      return;
    }

    try {
      final user = UserModel.fromJson(userInfoJson, '');
      userId.value = user.id;
    } catch (_) {
      AppHelperFunction.showSnackBar('Không thể đọc thông tin người dùng hiện tại');
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          endDate.value ??
          (startDate.value?.add(const Duration(days: 30)) ??
              DateTime.now().add(const Duration(days: 30))),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      endDate.value = picked;
    }
  }

  void updateTargetAmount(String value) {
    targetAmount.value = double.tryParse(value);
  }

  Future<bool> submitCreateFund() async {
    if (userId.value == null) {
      AppHelperFunction.showSnackBar('Không thể xác định người dùng hiện tại');
      return false;
    }

    if (startDate.value == null) {
      AppHelperFunction.showSnackBar('Vui lòng chọn ngày bắt đầu');
      return false;
    }

    if (endDate.value == null) {
      AppHelperFunction.showSnackBar('Vui lòng chọn ngày kết thúc');
      return false;
    }

    if (endDate.value!.isBefore(startDate.value!)) {
      AppHelperFunction.showSnackBar('Ngày kết thúc phải sau ngày bắt đầu');
      return false;
    }

    if (!validatePercentages()) {
      AppHelperFunction.showSnackBar(
        'Tổng phần trăm phải là 100%. Hiện tại là: ${totalPercentage.value}%',
      );
      return false;
    }

    final dto = SavingFundDto(
      categories: categories.toList(),
      name: fundNameController.text.trim(),
      id: isEditMode.value ? editingFundId.value : userId.value,
      amount: targetAmount.value,
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

  // cần sửa sau
  void _updateTotalPercentage() {
    final sum = categories.fold<int>(0, (sum, cat) => sum + cat.percentage);
    totalPercentage.value = sum;
  }

  Future<bool> createFund(SavingFundDto dto) async {
    isLoading.value = true;
    final result = await createSavingFundUseCase(dto);
    final isSuccess = result.fold(
      (failure) {
        AppHelperFunction.showSnackBar(failure.message);
        return false;
      },
      (fund) {
        savingFundController.savingFunds.add(fund);
        savingFundController.savingFunds.refresh();
        _resetForm();
        AppHelperFunction.showSnackBar('Tạo quỹ tiết kiệm thành công');
        return true;
      },
    );
    isLoading.value = false;
    return isSuccess;
  }

  void _resetForm() {
    fundNameController.clear();
    targetAmountController.clear();
    categories.clear();
    userId.value = null;
    totalPercentage.value = 0;
    targetAmount.value = null;
    startDate.value = null;
    endDate.value = null;
  }
}
