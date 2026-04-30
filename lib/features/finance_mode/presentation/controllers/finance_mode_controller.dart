import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/domain/repositories/finance_mode_repository.dart';
import 'package:money_care/features/finance_mode/domain/usecases/usecases.dart';

class FinanceModeController extends GetxController {
  final GetFinanceModeUseCase _getFinanceModeUseCase;
  final SwitchFinanceModeUseCase _switchFinanceModeUseCase;
  final CheckSuggestModeUseCase _checkSuggestModeUseCase;
  final FinanceModeRepository _repository;
  final AppController _appController;

  FinanceModeController({
    required GetFinanceModeUseCase getFinanceModeUseCase,
    required SwitchFinanceModeUseCase switchFinanceModeUseCase,
    required CheckSuggestModeUseCase checkSuggestModeUseCase,
    required FinanceModeRepository repository,
    required AppController appController,
  }) : _getFinanceModeUseCase = getFinanceModeUseCase,
       _switchFinanceModeUseCase = switchFinanceModeUseCase,
       _checkSuggestModeUseCase = checkSuggestModeUseCase,
       _repository = repository,
       _appController = appController;

  final Rx<FinanceMode> currentMode = FinanceMode.normal.obs;

  final Rx<Color> themeColor = AppColors.primary.obs;

  DateTime? _cooldownUntil;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentMode();
  }

  Future<void> _loadCurrentMode() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    final result = await _getFinanceModeUseCase(userId);
    result.fold((_) {}, (entity) {
      currentMode.value = entity.mode;
      themeColor.value = colorForMode(entity.mode);
      _cooldownUntil = entity.suggestionCooldownUntil;
    });
  }

  Future<void> switchMode(FinanceMode mode) async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    final oldMode = currentMode.value;
    final oldColor = themeColor.value;

    currentMode.value = mode;
    themeColor.value = colorForMode(mode);

    final result = await _switchFinanceModeUseCase(
      SwitchFinanceModeParams(userId: userId, mode: mode),
    );

    result.fold(
      (failure) {
        currentMode.value = oldMode;
        themeColor.value = oldColor;
        AppHelperFunction.showErrorSnackBar(
          'Không thể chuyển sang chế độ ${mode.name}. Vui lòng thử lại!',
        );
      },
      (entity) {
        currentMode.value = entity.mode;
        themeColor.value = colorForMode(entity.mode);
        _cooldownUntil = entity.suggestionCooldownUntil;
      },
    );
  }

  Future<FinanceMode?> checkAndSuggestMode(double spentPercent) async {
    if (!canSuggest()) return null;

    final userId = await _appController.getCurrentUserId();
    if (userId == null) return null;

    final result = await _checkSuggestModeUseCase(
      userId: userId,
      spentPercent: spentPercent,
    );

    return result.fold((_) => null, (suggested) => suggested);
  }

  Future<void> declineSuggestion() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    final cooldownEnd = DateTime.now().add(const Duration(hours: 24));
    _cooldownUntil = cooldownEnd;

    final currentResult = await _getFinanceModeUseCase(userId);
    await currentResult.fold((_) async {}, (entity) async {
      final updated = FinanceModeEntity(
        userId: entity.userId,
        mode: entity.mode,
        updatedAt: entity.updatedAt,
        suggestionCooldownUntil: cooldownEnd,
      );
      await _repository.saveFinanceMode(updated);
    });
  }

  bool canSuggest() {
    if (_cooldownUntil == null) return true;
    return DateTime.now().isAfter(_cooldownUntil!);
  }

  static Color colorForMode(FinanceMode mode) {
    switch (mode) {
      case FinanceMode.normal:
        return AppColors.primary;
      case FinanceMode.saving:
        return AppColors.warning;
      case FinanceMode.survival:
        return AppColors.error;
    }
  }
}
