import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

enum FundType { spending, savingGoal }

/// Unified financial fund entity replacing separate GoalFundEntity and BudgetEntity.
///
/// - [FundType.spending]: Wallet for daily expenses. Supports monthly spending limits.
/// - [FundType.savingGoal]: Piggy bank for reaching a monetary target.
class FundEntity {
  final int id;
  final String name;
  final FundType type;
  final bool? isSelected;
  final List<CategoryEntity> categories;

  // ── SPENDING wallet fields ───────────────────────────────────────────────────

  /// Main balance / spending capacity (formerly `balance`).
  final double? balance;

  /// Optional monthly spending cap.
  final double? monthlyLimit;

  /// Total spent in the current calendar month.
  final double spentCurrentMonth;

  final bool notified70;
  final bool notified90;

  // ── SAVING GOAL fields ───────────────────────────────────────────────────────

  /// Target amount to save (also used as spending ceiling for SPENDING funds).
  final double? target;

  /// Amount manually saved toward the goal.
  final double savedAmount;

  final bool isCompleted;

  /// Template key: 'laptop' | 'travel' | 'course' | null.
  final String? templateKey;

  // ── Common ───────────────────────────────────────────────────────────────────

  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const FundEntity({
    required this.id,
    required this.name,
    this.type = FundType.spending,
    this.isSelected,
    this.categories = const [],
    this.balance,
    this.monthlyLimit,
    this.spentCurrentMonth = 0,
    this.notified70 = false,
    this.notified90 = false,
    this.target,
    this.savedAmount = 0,
    this.isCompleted = false,
    this.templateKey,
    this.startDate,
    this.endDate,
    this.status,
  });

  // ── Computed helpers (SAVING_GOAL) ───────────────────────────────────────────

  double get progressPercent {
    final t = target ?? 0;
    if (t <= 0) return 0;
    final p = (savedAmount / t) * 100;
    return p > 100 ? 100 : p;
  }

  int get monthlySavingsNeeded {
    if (endDate == null || target == null) return 0;
    final now = DateTime.now();
    if (endDate!.isBefore(now) || isCompleted) return 0;
    final remaining = (target ?? 0) - savedAmount;
    if (remaining <= 0) return 0;
    final months = (endDate!.year - now.year) * 12 + (endDate!.month - now.month);
    if (months <= 0) return remaining.ceil();
    return (remaining / months).ceil();
  }

  // ── Computed helpers (SPENDING) ──────────────────────────────────────────────

  double get monthlyLimitUsagePercent {
    if ((monthlyLimit ?? 0) <= 0) return 0;
    return (spentCurrentMonth / monthlyLimit!) * 100;
  }

  bool get isOverMonthlyLimit =>
      (monthlyLimit ?? 0) > 0 && spentCurrentMonth > (monthlyLimit ?? 0);

  // ── EXPIRATION helpers ──────────────────────────────────────────────────────

  bool get isExpired {
    if (endDate == null) return false;
    return endDate!.isBefore(DateTime.now());
  }

  int get daysSinceExpired {
    if (!isExpired || endDate == null) return 0;
    return DateTime.now().difference(endDate!).inDays;
  }
}
