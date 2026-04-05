import 'package:get/get.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/services/notification_service.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';
import 'package:money_care/features/student_profile/domain/usecases/usecases.dart';

/// Service that checks exam periods when the app opens and sends
/// appropriate notifications.
///
/// Requirements: 9.2, 9.3, 9.4
class ExamPeriodNotificationService {
  final GetStudentProfileUseCase _getStudentProfileUseCase;
  final NotificationService _notificationService;
  final AppController _appController;

  ExamPeriodNotificationService({
    required GetStudentProfileUseCase getStudentProfileUseCase,
    required NotificationService notificationService,
    required AppController appController,
  })  : _getStudentProfileUseCase = getStudentProfileUseCase,
        _notificationService = notificationService,
        _appController = appController;

  /// Returns true when [today] falls within any of the given [periods].
  ///
  /// Property 28: isInExamPeriod(today, periods) returns true when
  /// startDate <= today <= endDate for at least one period.
  static bool isInExamPeriod(DateTime today, List<ExamPeriod> periods) {
    final todayDate = _dateOnly(today);
    return periods.any((p) {
      final start = _dateOnly(p.startDate);
      final end = _dateOnly(p.endDate);
      return !todayDate.isBefore(start) && !todayDate.isAfter(end);
    });
  }

  /// Returns true when [today] is within the 7-day pre-exam window for [period].
  ///
  /// Property 29: isInPreExamWindow(today, period) returns true when
  /// period.startDate - 7 days <= today < period.startDate.
  static bool isInPreExamWindow(DateTime today, ExamPeriod period) {
    final todayDate = _dateOnly(today);
    final start = _dateOnly(period.startDate);
    final windowStart = start.subtract(const Duration(days: 7));
    return !todayDate.isBefore(windowStart) && todayDate.isBefore(start);
  }

  /// Returns the active exam period for [today], or null if none.
  static ExamPeriod? activeExamPeriod(DateTime today, List<ExamPeriod> periods) {
    final todayDate = _dateOnly(today);
    for (final p in periods) {
      final start = _dateOnly(p.startDate);
      final end = _dateOnly(p.endDate);
      if (!todayDate.isBefore(start) && !todayDate.isAfter(end)) {
        return p;
      }
    }
    return null;
  }

  /// Checks exam periods and sends notifications if applicable.
  ///
  /// Call this when the app opens (e.g., from AppController or HomeController).
  ///
  /// - Req 9.2: Sends notification when within 7 days before an exam.
  /// - Req 9.3: Exposes [isCurrentlyInExamPeriod] for BudgetProgressBar.
  Future<void> checkOnAppOpen() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    final result = await _getStudentProfileUseCase(userId);
    result.fold(
      (_) {}, // silently ignore errors
      (profile) async {
        final today = DateTime.now();
        final periods = profile.examPeriods;

        // Req 9.2: notify if within 7-day pre-exam window
        for (final period in periods) {
          if (isInPreExamWindow(today, period)) {
            await _notificationService.showLocalNotification(
              id: 920,
              title: 'Mùa thi sắp đến',
              body:
                  'Mùa thi sắp đến — hãy chuẩn bị ngân sách cho sách vở và ôn thi nhé!',
            );
            break; // send at most one pre-exam notification per check
          }
        }
      },
    );
  }

  static DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}

/// Reactive wrapper that exposes exam period state to the rest of the app.
///
/// Register as a GetX singleton so BudgetProgressBar and
/// TransactionFormController can read [isInExamPeriod].
class ExamPeriodController extends GetxController {
  final ExamPeriodNotificationService _service;

  ExamPeriodController({required ExamPeriodNotificationService service})
      : _service = service;

  /// True while the current date falls inside an exam period (Req 9.3).
  final RxBool isInExamPeriod = false.obs;

  /// The list of exam periods loaded from the student profile.
  final RxList<ExamPeriod> examPeriods = <ExamPeriod>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkExamPeriods();
  }

  /// Loads the student profile, updates [isInExamPeriod], and sends
  /// pre-exam notifications if applicable (Req 9.2, 9.3).
  Future<void> checkExamPeriods() async {
    await _service.checkOnAppOpen();

    // Re-read the profile to update reactive state
    final appController = Get.find<AppController>();
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;

    final getUseCase = _service._getStudentProfileUseCase;
    final result = await getUseCase(userId);
    result.fold(
      (_) {},
      (profile) {
        examPeriods.assignAll(profile.examPeriods);
        isInExamPeriod.value = ExamPeriodNotificationService.isInExamPeriod(
          DateTime.now(),
          profile.examPeriods,
        );
      },
    );
  }
}
