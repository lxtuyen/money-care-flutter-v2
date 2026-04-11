import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  })  : _getFinanceModeUseCase = getFinanceModeUseCase,
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
    result.fold(
      (_) {},
      (entity) {
        currentMode.value = entity.mode;
        themeColor.value = colorForMode(entity.mode);
        _cooldownUntil = entity.suggestionCooldownUntil;
      },
    );
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
        Get.snackbar(
          'Lỗi',
          'Không thể chuyển sang chế độ ${mode.name}. Vui lòng thử lại!',
          backgroundColor: AppColors.error.withOpacity(0.1),
          colorText: AppColors.error,
        );
      },
      (entity) {
        currentMode.value = entity.mode;
        themeColor.value = colorForMode(entity.mode);
        _cooldownUntil = entity.suggestionCooldownUntil;
      },
    );
  }

  /// Check spending percentage and suggest a mode change if appropriate.
  ///
  /// Returns the suggested [FinanceMode] if a suggestion should be shown,
  /// or `null` if no suggestion is needed or cooldown is active (Req 5.3, 5.4, 5.5).
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

  /// Decline a suggestion and start the 24-hour cooldown (Req 5.5).
  ///
  /// Call this when the user dismisses a mode suggestion dialog.
  Future<void> declineSuggestion() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    final cooldownEnd = DateTime.now().add(const Duration(hours: 24));
    _cooldownUntil = cooldownEnd;

    // Persist the cooldown by saving an updated entity with the new cooldown.
    final currentResult = await _getFinanceModeUseCase(userId);
    await currentResult.fold(
      (_) async {},
      (entity) async {
        final updated = FinanceModeEntity(
          userId: entity.userId,
          mode: entity.mode,
          updatedAt: entity.updatedAt,
          suggestionCooldownUntil: cooldownEnd,
        );
        await _repository.saveFinanceMode(updated);
      },
    );
  }

  /// Returns `false` if a 24-hour cooldown is currently active (Req 5.5).
  bool canSuggest() {
    if (_cooldownUntil == null) return true;
    return DateTime.now().isAfter(_cooldownUntil!);
  }

  /// Maps a [FinanceMode] to its corresponding theme color (Req 5.6).
  static Color colorForMode(FinanceMode mode) {
    switch (mode) {
      case FinanceMode.normal:
        return AppColors.success; // green
      case FinanceMode.saving:
        return AppColors.warning; // yellow/amber
      case FinanceMode.survival:
        return AppColors.error; // red
    }
  }
}
