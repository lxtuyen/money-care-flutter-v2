import 'package:get/get.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/services/notification_service.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/domain/usecases/usecases.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_dialog.dart';

/// GetX controller for the Gamification Engine.
///
/// Tracks the user's daily transaction streak and badge collection.
/// Call [recordDailyTransaction] after every new transaction is saved.
/// On app open, [onInit] calls [checkStreakReset] to detect missed days.
///
/// Requirements: 8.1, 8.2, 8.3
class GamificationController extends GetxController {
  final GetGamificationUseCase _getGamificationUseCase;
  final RecordDailyTransactionUseCase _recordDailyTransactionUseCase;
  final CheckAndAwardBadgesUseCase _checkAndAwardBadgesUseCase;
  final NotificationService _notificationService;
  final AppController _appController;

  GamificationController({
    required GetGamificationUseCase getGamificationUseCase,
    required RecordDailyTransactionUseCase recordDailyTransactionUseCase,
    required CheckAndAwardBadgesUseCase checkAndAwardBadgesUseCase,
    required NotificationService notificationService,
    required AppController appController,
  })  : _getGamificationUseCase = getGamificationUseCase,
        _recordDailyTransactionUseCase = recordDailyTransactionUseCase,
        _checkAndAwardBadgesUseCase = checkAndAwardBadgesUseCase,
        _notificationService = notificationService,
        _appController = appController;

  /// Current streak count — reactive, observed by [StreakBadgeWidget] (Req 8.2).
  final RxInt currentStreak = 0.obs;

  /// All badges earned by the user (Req 8.4, 8.5, 8.6, 8.8).
  final RxList<BadgeEntity> badges = <BadgeEntity>[].obs;
  
  /// Weekly progress (Mon-Sun) - true if transaction recorded on that day.
  final RxList<bool> weeklyProgress = RxList.generate(7, (_) => false);
  
  /// Trigger for Streak Dialog.
  final RxBool showStreakDialogTrigger = false.obs;

  /// Whether the controller is loading data.
  final RxBool isLoading = false.obs;

  /// Cached entity to avoid redundant fetches.
  GamificationEntity? _cachedEntity;

  @override
  void onInit() {
    super.onInit();
    
    // Sync khi user thay đổi
    ever(_appController.userId, (id) {
      if (id != null) {
        checkStreakReset();
      } else {
        currentStreak.value = 0;
        badges.clear();
        weeklyProgress.assignAll(List.generate(7, (_) => false));
      }
    });

    ever(showStreakDialogTrigger, (val) {
      print('[STREAK] showStreakDialogTrigger changed to: $val');
      if (val) {
        // Đợi 500ms để màn hình tạo giao dịch đóng xong rồi mới hiện dialog
        Future.delayed(const Duration(milliseconds: 500), () {
          print('[STREAK] EXECUTING StreakDialog.show(). Streak: ${currentStreak.value}');
          StreakDialog.show();
          showStreakDialogTrigger.value = false;
        });
      }
    });

    final currentId = _appController.userId.value;
    if (currentId != null) checkStreakReset();
  }

  /// Cập nhật tiến độ tuần (Th 2 - CN)
  void updateWeeklyProgress() {
    if (!Get.isRegistered<TransactionController>()) return;
    
    final txController = Get.find<TransactionController>();
    final txData = txController.transactionByfilter.value;
    if (txData == null) return;

    final allTxs = [...txData.expenseTransactions, ...txData.incomeTransactions];
    
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final mondayDate = DateTime(monday.year, monday.month, monday.day);
    
    final List<bool> progress = List.generate(7, (_) => false);
    
    for (final tx in allTxs) {
      if (tx.transactionDate == null) continue;
      final txDate = DateTime(tx.transactionDate!.year, tx.transactionDate!.month, tx.transactionDate!.day);
      final diff = txDate.difference(mondayDate).inDays;
      
      if (diff >= 0 && diff < 7) {
        progress[diff] = true;
      }
    }
    
    weeklyProgress.assignAll(progress);
  }

  /// Load gamification state and reset streak if a day was missed (Req 8.3).
  ///
  /// Called on app open. Compares [lastTransactionDate] with today:
  /// - If more than 1 day has passed since the last transaction, the streak
  ///   is already 0 on the backend (reset at 00:00 the next day).
  /// - We reload from backend to get the authoritative state.
  Future<void> checkStreakReset() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    isLoading.value = true;
    print('[STREAK] checkStreakReset starting for user: $userId');

    final result = await _getGamificationUseCase(userId);
    result.fold(
      (failure) {
         print('[STREAK] checkStreakReset FETCH ERROR: $failure');
      },
      (entity) {
        print('[STREAK] checkStreakReset fetched: Streak=${entity.currentStreak}, LastDate=${entity.lastTransactionDate}');
        _cachedEntity = entity;
        currentStreak.value = _computeEffectiveStreak(entity);
        badges.value = entity.badges;
        
        // Cập nhật tiến độ tuần ngay khi load
        updateWeeklyProgress();
      },
    );

    isLoading.value = false;
  }

  /// Compute the effective streak, resetting to 0 if a day was missed (Req 8.3).
  ///
  /// The backend resets at 00:00, but if the app was opened before the backend
  /// processed the reset, we apply the reset client-side.
  int _computeEffectiveStreak(GamificationEntity entity) {
    if (entity.lastTransactionDate == null) return 0;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastDate = DateTime(
      entity.lastTransactionDate!.year,
      entity.lastTransactionDate!.month,
      entity.lastTransactionDate!.day,
    );

    final daysDiff = todayDate.difference(lastDate).inDays;

    // If more than 1 day has passed without a transaction, streak is 0 (Req 8.3)
    if (daysDiff > 1) return 0;

    return entity.currentStreak;
  }

  /// Record a transaction for today and update the streak (Req 8.1, 8.2).
  ///
  /// Should be called after every new transaction is successfully saved.
  /// If the user already recorded a transaction today, the streak is unchanged.
  Future<void> recordDailyTransaction() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

    // Lưu lại ngày giao dịch cuối cùng trước khi cập nhật
    final oldLastDate = _cachedEntity?.lastTransactionDate;
    print('[STREAK] Old Last Date: $oldLastDate');

    final result = await _recordDailyTransactionUseCase(userId);
    await result.fold(
      (failure) async {
        print('[STREAK] Error recording transaction: $failure');
      },
      (entity) async {
        final newDate = entity.lastTransactionDate;
        print('[STREAK] New Last Date from Backend: $newDate');

        // Logic check ngày mới: so sánh Year/Month/Day
        bool isNewDay = false;
        if (oldLastDate == null && newDate != null) {
          isNewDay = true;
        } else if (oldLastDate != null && newDate != null) {
          final oldD = DateTime(oldLastDate.year, oldLastDate.month, oldLastDate.day);
          final newD = DateTime(newDate.year, newDate.month, newDate.day);
          isNewDay = newD.isAfter(oldD);
        }

        print('[STREAK] Is New Day for Dialog: $isNewDay');

        _cachedEntity = entity;
        currentStreak.value = entity.currentStreak;
        badges.value = entity.badges;

        // Cập nhật tiến độ tuần sau khi ghi nhận
        updateWeeklyProgress();

        // Check and award streak badges after updating (Req 8.4, 8.5)
        await checkAndAwardBadges();

        // Chỉ kích hoạt dialog nếu là ngày mới trong chuỗi
        if (isNewDay) {
          print('[STREAK] Triggering Streak Dialog...');
          showStreakDialogTrigger.value = true;
        }
      },
    );
  }

  /// Check streak thresholds and award badges if conditions are met (Req 8.4, 8.5, 8.9).
  ///
  /// Also accepts [goalCompleted] = true to award the goal badge (Req 8.6).
  Future<void> checkAndAwardBadges({bool goalCompleted = false}) async {
    final entity = _cachedEntity;
    if (entity == null) return;

    final badgesBefore = List<BadgeEntity>.from(entity.badges);

    final result = await _checkAndAwardBadgesUseCase(
      entity,
      goalCompleted: goalCompleted,
    );

    await result.fold(
      (_) async {},
      (updated) async {
        _cachedEntity = updated;
        badges.value = updated.badges;

        // Notify for each newly awarded badge (Req 8.7)
        final newBadges = updated.badges
            .where((b) => !badgesBefore.any((old) => old.key == b.key))
            .toList();

        for (final badge in newBadges) {
          await _notificationService.showLocalNotification(
            id: badge.key.hashCode,
            title: 'Huy hiệu mới!',
            body: 'Chúc mừng! Bạn đã đạt được huy hiệu "${badge.name}"',
          );
        }
      },
    );
  }
}
