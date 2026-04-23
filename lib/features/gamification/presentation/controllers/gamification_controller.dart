import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/services/notification_service.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_dialog.dart';

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
  }) : _getGamificationUseCase = getGamificationUseCase,
       _recordDailyTransactionUseCase = recordDailyTransactionUseCase,
       _checkAndAwardBadgesUseCase = checkAndAwardBadgesUseCase,
       _notificationService = notificationService,
       _appController = appController;

  final RxInt currentStreak = 0.obs;

  final RxList<BadgeEntity> badges = <BadgeEntity>[].obs;

  final RxList<bool> weeklyProgress = RxList.generate(7, (_) => false);

  final RxBool showStreakDialogTrigger = false.obs;

  final RxBool isLoading = false.obs;

  GamificationEntity? _cachedEntity;

  @override
  void onInit() {
    super.onInit();

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
        Future.delayed(const Duration(milliseconds: 500), () {
          print(
            '[STREAK] EXECUTING StreakDialog.show(). Streak: ${currentStreak.value}',
          );
          StreakDialog.show();
          showStreakDialogTrigger.value = false;
        });
      }
    });

    final currentId = _appController.userId.value;
    if (currentId != null) checkStreakReset();
  }

  void updateWeeklyProgress() {
    if (!Get.isRegistered<TransactionController>()) return;

    final txController = Get.find<TransactionController>();
    final txData = txController.recentTransactions.value;
    if (txData == null) return;

    final allTxs = [
      ...txData.expenseTransactions,
      ...txData.incomeTransactions,
    ];

    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final mondayDate = DateTime(monday.year, monday.month, monday.day);

    final List<bool> progress = List.generate(7, (_) => false);

    for (final tx in allTxs) {
      if (tx.transactionDate == null) continue;
      final txDate = DateTime(
        tx.transactionDate!.year,
        tx.transactionDate!.month,
        tx.transactionDate!.day,
      );
      final diff = txDate.difference(mondayDate).inDays;

      if (diff >= 0 && diff < 7) {
        progress[diff] = true;
      }
    }

    weeklyProgress.assignAll(progress);
  }

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
        print(
          '[STREAK] checkStreakReset fetched: Streak=${entity.currentStreak}, LastDate=${entity.lastTransactionDate}',
        );
        _cachedEntity = entity;
        currentStreak.value = _computeEffectiveStreak(entity);
        badges.value = entity.badges;

        updateWeeklyProgress();
      },
    );

    isLoading.value = false;
  }

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

    if (daysDiff > 1) return 0;

    return entity.currentStreak;
  }

  Future<void> recordDailyTransaction() async {
    final userId = await _appController.getCurrentUserId();
    if (userId == null) return;

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

        bool isNewDay = false;
        if (oldLastDate == null && newDate != null) {
          isNewDay = true;
        } else if (oldLastDate != null && newDate != null) {
          final oldD = DateTime(
            oldLastDate.year,
            oldLastDate.month,
            oldLastDate.day,
          );
          final newD = DateTime(newDate.year, newDate.month, newDate.day);
          isNewDay = newD.isAfter(oldD);
        }

        _cachedEntity = entity;
        currentStreak.value = entity.currentStreak;
        badges.value = entity.badges;

        updateWeeklyProgress();

        await checkAndAwardBadges();

        if (isNewDay) {
          print('[STREAK] Triggering Streak Dialog...');
          showStreakDialogTrigger.value = true;
        }
      },
    );
  }

  Future<void> checkAndAwardBadges({bool goalCompleted = false}) async {
    final entity = _cachedEntity;
    if (entity == null) return;

    final badgesBefore = List<BadgeEntity>.from(entity.badges);

    final result = await _checkAndAwardBadgesUseCase(
      entity,
      goalCompleted: goalCompleted,
    );

    await result.fold((_) async {}, (updated) async {
      _cachedEntity = updated;
      badges.value = updated.badges;

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
    });
  }
}
