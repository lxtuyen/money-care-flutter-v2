/// Badge được cấp cho người dùng khi đạt mốc streak hoặc hoàn thành mục tiêu
/// Requirements: 8.4, 8.5, 8.6, 8.9
class BadgeEntity {
  final String key; // 'streak_7' | 'streak_30' | 'goal_completed'
  final String name;
  final DateTime awardedAt;

  const BadgeEntity({
    required this.key,
    required this.name,
    required this.awardedAt,
  });

  BadgeEntity copyWith({String? key, String? name, DateTime? awardedAt}) {
    return BadgeEntity(
      key: key ?? this.key,
      name: name ?? this.name,
      awardedAt: awardedAt ?? this.awardedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BadgeEntity && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Trạng thái gamification của người dùng: streak và danh sách badge
/// Requirements: 8.1, 8.2, 8.3, 8.9
class GamificationEntity {
  final int userId;
  final int currentStreak;
  final DateTime? lastTransactionDate;
  final List<BadgeEntity> badges;

  const GamificationEntity({
    required this.userId,
    required this.currentStreak,
    this.lastTransactionDate,
    required this.badges,
  });

  /// Kiểm tra xem badge đã được cấp chưa — Requirement 8.9 (idempotent)
  bool hasBadge(String key) => badges.any((b) => b.key == key);

  /// Tính streak mới dựa trên ngày giao dịch hôm nay
  /// Requirement 8.1, 8.2, 8.3
  GamificationEntity recordTransaction(DateTime today) {
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastTransactionDate == null) {
      // Giao dịch đầu tiên
      return copyWith(currentStreak: 1, lastTransactionDate: todayDate);
    }

    final lastDate = DateTime(
      lastTransactionDate!.year,
      lastTransactionDate!.month,
      lastTransactionDate!.day,
    );

    if (lastDate == todayDate) {
      // Đã ghi trong ngày hôm nay, không thay đổi streak
      return this;
    }

    final yesterday = todayDate.subtract(const Duration(days: 1));
    if (lastDate == yesterday) {
      // Ngày liên tiếp — tăng streak
      return copyWith(
        currentStreak: currentStreak + 1,
        lastTransactionDate: todayDate,
      );
    }

    // Bỏ ngày — reset streak về 1
    return copyWith(currentStreak: 1, lastTransactionDate: todayDate);
  }

  /// Cấp badge nếu chưa có (idempotent) — Requirement 8.9
  GamificationEntity awardBadge(BadgeEntity badge) {
    if (hasBadge(badge.key)) return this;
    return copyWith(badges: [...badges, badge]);
  }

  GamificationEntity copyWith({
    int? userId,
    int? currentStreak,
    DateTime? lastTransactionDate,
    List<BadgeEntity>? badges,
  }) {
    return GamificationEntity(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      lastTransactionDate: lastTransactionDate ?? this.lastTransactionDate,
      badges: badges ?? this.badges,
    );
  }
}

/// Các badge key chuẩn — Requirements: 8.4, 8.5, 8.6
class BadgeKeys {
  static const String streak7 = 'streak_7';
  static const String streak30 = 'streak_30';
  static const String goalCompleted = 'goal_completed';
}

/// Tên hiển thị của badge
class BadgeNames {
  static const String streak7 = 'Tiết kiệm 7 ngày';
  static const String streak30 = 'Tiết kiệm 30 ngày';
  static const String goalCompleted = 'Mục tiêu hoàn thành';
}
