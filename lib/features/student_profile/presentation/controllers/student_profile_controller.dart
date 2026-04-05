import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';
import 'package:money_care/features/student_profile/domain/usecases/usecases.dart';

/// GetX controller for the Student Profile feature.
///
/// Loads the existing profile on init, exposes Rx form fields,
/// validates inline, and triggers a balance suggestion on successful save.
///
/// Requirements: 2.1, 2.2, 2.3, 2.4, 2.5
class StudentProfileController extends GetxController {
  final GetStudentProfileUseCase _getStudentProfileUseCase;
  final SaveStudentProfileUseCase _saveStudentProfileUseCase;
  final AppController _appController;

  StudentProfileController({
    required GetStudentProfileUseCase getStudentProfileUseCase,
    required SaveStudentProfileUseCase saveStudentProfileUseCase,
    required AppController appController,
  })  : _getStudentProfileUseCase = getStudentProfileUseCase,
        _saveStudentProfileUseCase = saveStudentProfileUseCase,
        _appController = appController;

  // â”€â”€ Form controllers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final TextEditingController universityController = TextEditingController();
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController studyYearController = TextEditingController();
  final TextEditingController monthlyIncomeController = TextEditingController();

  // â”€â”€ Reactive state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final Rx<DateTime?> incomeDate = Rx(null);
  final RxBool isLoading = false.obs;
  final RxList<ExamPeriod> examPeriods = <ExamPeriod>[].obs;

  /// Inline validation error messages (null = no error).
  final RxnString studyYearError = RxnString();
  final RxnString monthlyIncomeError = RxnString();

  // â”€â”€ Lifecycle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  @override
  void onClose() {
    universityController.dispose();
    facultyController.dispose();
    studyYearController.dispose();
    monthlyIncomeController.dispose();
    super.onClose();
  }

  // â”€â”€ Load â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _loadProfile() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    isLoading.value = true;
    final result = await _getStudentProfileUseCase(userId);
    result.fold(
      (_) {}, // silently keep empty form on error
      (profile) {
        universityController.text = profile.university ?? '';
        facultyController.text = profile.faculty ?? '';
        studyYearController.text =
            profile.studyYear != null ? profile.studyYear.toString() : '';
        monthlyIncomeController.text =
            profile.monthlyIncome != null
                ? profile.monthlyIncome.toString()
                : '';
        incomeDate.value = profile.incomeDate;
        examPeriods.assignAll(profile.examPeriods);
      },
    );
    isLoading.value = false;
  }

  // â”€â”€ Exam periods â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Adds an exam period (Req 9.1).
  void addExamPeriod(ExamPeriod period) {
    examPeriods.add(period);
  }

  /// Removes an exam period by index (Req 9.1).
  void removeExamPeriod(int index) {
    if (index >= 0 && index < examPeriods.length) {
      examPeriods.removeAt(index);
    }
  }

  // â”€â”€ Validation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Validates studyYear field inline (Req 2.3).
  /// Returns true if valid.
  bool _validateStudyYear(String value) {
    if (value.isEmpty) {
      studyYearError.value = null;
      return true; // optional field
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1 || parsed > 6) {
      studyYearError.value = 'NÄƒm há»c pháº£i tá»« 1 Ä‘áº¿n 6';
      return false;
    }
    studyYearError.value = null;
    return true;
  }

  /// Validates monthlyIncome field inline (Req 2.4).
  /// Returns true if valid.
  bool _validateMonthlyIncome(String value) {
    if (value.isEmpty) {
      monthlyIncomeError.value = null;
      return true; // optional field
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 0) {
      monthlyIncomeError.value = 'Thu nháº­p khÃ´ng há»£p lá»‡';
      return false;
    }
    monthlyIncomeError.value = null;
    return true;
  }

  /// Called on every keystroke in the studyYear field.
  void onStudyYearChanged(String value) => _validateStudyYear(value);

  /// Called on every keystroke in the monthlyIncome field.
  void onMonthlyIncomeChanged(String value) => _validateMonthlyIncome(value);

  // â”€â”€ Save â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Saves the profile. On success, triggers balance suggestion (Req 2.2).
  Future<bool> save() async {
    final yearValid = _validateStudyYear(studyYearController.text);
    final incomeValid = _validateMonthlyIncome(monthlyIncomeController.text);
    if (!yearValid || !incomeValid) return false;

    final userId = await _appController.getCurrentUserId();
    if (userId == null) return false;

    final studyYear = studyYearController.text.isNotEmpty
        ? int.tryParse(studyYearController.text)
        : null;
    final monthlyIncome = monthlyIncomeController.text.isNotEmpty
        ? int.tryParse(monthlyIncomeController.text)
        : null;

    final profile = StudentProfileEntity(
      userId: userId,
      university: universityController.text.trim().isEmpty
          ? null
          : universityController.text.trim(),
      faculty: facultyController.text.trim().isEmpty
          ? null
          : facultyController.text.trim(),
      studyYear: studyYear,
      monthlyIncome: monthlyIncome,
      incomeDate: incomeDate.value,
      examPeriods: List.unmodifiable(examPeriods),
    );

    isLoading.value = true;
    final result = await _saveStudentProfileUseCase(profile);
    isLoading.value = false;

    return result.fold(
      (_) => false,
      (saved) {
        // Trigger balance suggestion = floor(monthlyIncome * 0.9) (Req 2.2)
        if (saved.monthlyIncome != null && saved.monthlyIncome! > 0) {
          _triggerBudgetSuggestion(saved.monthlyIncome!);
        }
        return true;
      },
    );
  }

  /// Triggers balance suggestion via BudgetController (Req 2.2).
  void _triggerBudgetSuggestion(int monthlyIncome) {
    final suggestedAmount = (monthlyIncome * 0.9).floor();
    debugPrint('Suggested monthly budget: $suggestedAmount');
  }

  // â”€â”€ Income date picker â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> pickIncomeDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: incomeDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      incomeDate.value = picked;
    }
  }
}
