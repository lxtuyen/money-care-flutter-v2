import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

enum OnboardingStep {
  welcome,
  incomeInfo,
  balanceSetup,
  complete,
}

class OnboardingController extends GetxController {
  final LocalStorage storage;

  OnboardingController({required this.storage});

  final Rx<OnboardingStep> currentStep = OnboardingStep.welcome.obs;

  final RxMap<int, bool> skippedSteps = <int, bool>{}.obs;

  static const String _stepKeyPrefix = 'onboarding_step_';
  static const String _skippedKeyPrefix = 'onboarding_skipped_';

  @override
  void onInit() {
    super.onInit();
    _restoreStep();
  }

  Future<void> _restoreStep() async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final savedStepIndex = storage.readInt('$_stepKeyPrefix$userId');
    if (savedStepIndex != null &&
        savedStepIndex >= 0 &&
        savedStepIndex < OnboardingStep.values.length) {
      currentStep.value = OnboardingStep.values[savedStepIndex];
    }

    // Khôi phục trạng thái bỏ qua của từng bước
    for (final step in OnboardingStep.values) {
      final wasSkipped =
          storage.readBool('$_skippedKeyPrefix${userId}_${step.index}') ??
          false;
      if (wasSkipped) {
        skippedSteps[step.index] = true;
      }
    }
  }

  Future<void> _saveCurrentStep(OnboardingStep step) async {
    final userId = _getCurrentUserId();
    if (userId == null) return;
    await storage.writeInt('$_stepKeyPrefix$userId', step.index);
  }

  int? _getCurrentUserId() {
    try {
      return Get.find<AppController>().userId.value ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> goToNextStep() async {
    final nextIndex = currentStep.value.index + 1;
    if (nextIndex < OnboardingStep.values.length) {
      currentStep.value = OnboardingStep.values[nextIndex];
      await _saveCurrentStep(currentStep.value);
    }
  }

  Future<void> goToStep(OnboardingStep step) async {
    currentStep.value = step;
    await _saveCurrentStep(step);
  }

  Future<void> skipCurrentStep() async {
    final userId = _getCurrentUserId();
    final stepIndex = currentStep.value.index;

    skippedSteps[stepIndex] = true;
    if (userId != null) {
      await storage.writeBool('$_skippedKeyPrefix${userId}_$stepIndex', true);
    }

    await goToNextStep();
  }

  Future<void> completeStep(OnboardingStep step) async {
    final userId = _getCurrentUserId();
    final stepIndex = step.index;

    skippedSteps.remove(stepIndex);
    if (userId != null) {
      await storage.writeBool('$_skippedKeyPrefix${userId}_$stepIndex', false);
    }
  }

  Future<void> completeIncomeInfoStep() async {
    await completeStep(OnboardingStep.incomeInfo);
    await goToStep(OnboardingStep.balanceSetup);
  }

  bool get hasSkippedSteps => skippedSteps.values.any((skipped) => skipped);

  List<OnboardingStep> get skippedStepsList {
    return OnboardingStep.values
        .where((step) => skippedSteps[step.index] == true)
        .toList();
  }

  Future<void> completeOnboarding({required String nextRoute}) async {
    try {
      await storage.saveOnboardingSeen();
      final userId = _getCurrentUserId();
      if (userId != null) {
        await storage.remove('$_stepKeyPrefix$userId');
      }
      Get.toNamed(nextRoute);
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(
        'Không thể lưu trạng thái onboarding',
      );
    }
  }

  int get totalSteps => OnboardingStep.values.length;

  int get currentStepIndex => currentStep.value.index;
}
