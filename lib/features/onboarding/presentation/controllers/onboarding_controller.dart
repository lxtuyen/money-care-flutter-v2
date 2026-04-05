import 'package:get/get.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

/// Các bước trong luồng onboarding sinh viên
enum OnboardingStep {
  welcome,        // Bước 1: Chào mừng
  studentInfo,    // Bước 2: Thông tin sinh viên
  balanceSetup,    // Bước 3: Thiết lập ngân sách
  categorySelect, // Bước 4: Chọn danh mục
  complete,       // Bước 5: Hoàn thành
}

class OnboardingController extends GetxController {
  final LocalStorage storage;

  OnboardingController({required this.storage});

  final Rx<OnboardingStep> currentStep = OnboardingStep.welcome.obs;

  // Trạng thái bỏ qua của từng bước: key = OnboardingStep.index, value = true nếu đã bỏ qua
  final RxMap<int, bool> skippedSteps = <int, bool>{}.obs;

  static const String _stepKeyPrefix = 'onboarding_step_';
  static const String _skippedKeyPrefix = 'onboarding_skipped_';

  @override
  void onInit() {
    super.onInit();
    _restoreStep();
  }

  /// Khôi phục bước đang dở từ SharedPreferences theo userId
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

  /// Lưu bước hiện tại vào SharedPreferences
  Future<void> _saveCurrentStep(OnboardingStep step) async {
    final userId = _getCurrentUserId();
    if (userId == null) return;
    await storage.writeInt('$_stepKeyPrefix$userId', step.index);
  }

  /// Lấy userId từ AppController nếu đã đăng nhập, hoặc dùng key mặc định 0
  int? _getCurrentUserId() {
    try {
      return Get.find<AppController>().userId.value ?? 0;
    } catch (_) {
      // Nếu AppController chưa được đăng ký (ví dụ trong test), dùng key mặc định 0
      return 0;
    }
  }

  /// Chuyển sang bước tiếp theo và lưu trạng thái
  Future<void> goToNextStep() async {
    final nextIndex = currentStep.value.index + 1;
    if (nextIndex < OnboardingStep.values.length) {
      currentStep.value = OnboardingStep.values[nextIndex];
      await _saveCurrentStep(currentStep.value);
    }
  }

  /// Chuyển sang bước cụ thể và lưu trạng thái
  Future<void> goToStep(OnboardingStep step) async {
    currentStep.value = step;
    await _saveCurrentStep(step);
  }

  /// Bỏ qua bước hiện tại: lưu trạng thái skipped và chuyển sang bước tiếp
  Future<void> skipCurrentStep() async {
    final userId = _getCurrentUserId();
    final stepIndex = currentStep.value.index;

    // Lưu trạng thái đã bỏ qua
    skippedSteps[stepIndex] = true;
    if (userId != null) {
      await storage.writeBool(
        '$_skippedKeyPrefix${userId}_$stepIndex',
        true,
      );
    }

    await goToNextStep();
  }

  /// Hoàn thành một bước cụ thể (xóa trạng thái skipped nếu có)
  Future<void> completeStep(OnboardingStep step) async {
    final userId = _getCurrentUserId();
    final stepIndex = step.index;

    skippedSteps.remove(stepIndex);
    if (userId != null) {
      await storage.writeBool(
        '$_skippedKeyPrefix${userId}_$stepIndex',
        false,
      );
    }
  }

  /// Hoàn thành bước nhập thông tin sinh viên → chuyển sang bước thiết lập ngân sách
  /// Requirement 1.2: WHEN người dùng hoàn thành bước nhập thông tin sinh viên,
  /// THE Onboarding_Flow SHALL chuyển sang bước thiết lập ngân sách tháng đầu tiên.
  Future<void> completeStudentInfoStep() async {
    await completeStep(OnboardingStep.studentInfo);
    await goToStep(OnboardingStep.balanceSetup);
  }

  /// Kiểm tra xem có bước nào bị bỏ qua không (dùng cho ProfileScreen)
  bool get hasSkippedSteps => skippedSteps.values.any((skipped) => skipped);

  /// Danh sách các bước đã bỏ qua
  List<OnboardingStep> get skippedStepsList {
    return OnboardingStep.values
        .where((step) => skippedSteps[step.index] == true)
        .toList();
  }

  /// Hoàn thành toàn bộ onboarding và điều hướng đến route tiếp theo
  Future<void> completeOnboarding({required String nextRoute}) async {
    try {
      await storage.saveOnboardingSeen();
      // Xóa trạng thái bước đang dở
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

  /// Tổng số bước onboarding
  int get totalSteps => OnboardingStep.values.length;

  /// Chỉ số bước hiện tại (0-based)
  int get currentStepIndex => currentStep.value.index;
}
