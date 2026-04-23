import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
import 'package:money_care/features/saving_goal/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';

class CreateSavingGoalController extends GetxController {
  late final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();
  late final AppController appController = Get.find<AppController>();

  CreateSavingGoalUseCase get _createUseCase =>
      Get.find<CreateSavingGoalUseCase>();
  UpdateSavingGoalUseCase get _updateUseCase =>
      Get.find<UpdateSavingGoalUseCase>();

  Rxn<int> userId = Rxn<int>();
  RxBool isLoading = false.obs;
  RxBool isEditMode = false.obs;
  Rxn<int> editingGoalId = Rxn<int>();

  final nameController = TextEditingController();
  final targetController = TextEditingController();

  Rxn<double> target = Rxn<double>();
  Rxn<DateTime> startDate = Rxn<DateTime>();
  Rxn<DateTime> endDate = Rxn<DateTime>();

  @override
  void onClose() {
    nameController.dispose();
    targetController.dispose();
    super.onClose();
  }

  Future<void> initializeForm() async {
    await _initializeUserInfo();

    final arg = Get.arguments;
    if (arg is SavingGoalEntity) {
      isEditMode.value = true;
      editingGoalId.value = arg.id;
      nameController.text = arg.name;
      target.value = arg.target;
      targetController.text = arg.target?.toInt().toString() ?? '';
      startDate.value = arg.startDate;
      endDate.value = arg.endDate;
    } else {
      _resetForm();
      startDate.value = DateTime.now();
    }
  }

  Future<void> _initializeUserInfo() async {
    final id = await appController.getCurrentUserId();
    if (id == null) return;
    userId.value = id;
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showStyledDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
    );
    if (picked != null) startDate.value = picked;
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showStyledDatePicker(
      context: context,
      initialDate:
          endDate.value ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: startDate.value ?? DateTime.now(),
    );
    if (picked != null) endDate.value = picked;
  }

  Future<bool> submit() async {
    if (nameController.text.isEmpty) {
      AppHelperFunction.showErrorSnackBar('Vui lòng nhập tên mục tiêu');
      return false;
    }
    if (startDate.value == null || endDate.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn thời gian');
      return false;
    }

    final rawTarget = AppHelperFunction.unformatCurrency(targetController.text);
    final finalTarget = double.tryParse(rawTarget) ?? 0;

    final dto = SavingGoalDto(
      id: isEditMode.value ? editingGoalId.value : null,
      name: nameController.text.trim(),
      userId: userId.value,
      target: finalTarget,
      savedAmount: 0,
      startDate: startDate.value,
      endDate: endDate.value,
    );

    isLoading.value = true;
    final result = isEditMode.value
        ? await _updateUseCase(dto)
        : await _createUseCase(dto);

    return result.fold(
      (failure) {
        isLoading.value = false;
        AppHelperFunction.showErrorSnackBar(failure.message);
        return false;
      },
      (goal) {
        isLoading.value = false;
        savingGoalController.loadGoals(userId.value!);
        Get.back();
        AppHelperFunction.showSuccessSnackBar('Đã lưu mục tiêu tiết kiệm');
        return true;
      },
    );
  }

  void _resetForm() {
    nameController.clear();
    targetController.clear();
    target.value = null;
    startDate.value = DateTime.now();
    endDate.value = null;
    isEditMode.value = false;
  }
}
