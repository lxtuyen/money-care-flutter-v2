import 'couple_member_entity.dart';

class CoupleEntity {
  final int id;
  final String inviteCode;
  final String status; // 'pending' | 'active' | 'cancelled' | 'left'
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CoupleMemberEntity> members;
  final int currentStreak;
  final String? lastActivityDate;

  const CoupleEntity({
    required this.id,
    required this.inviteCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
    this.currentStreak = 0,
    this.lastActivityDate,
  });

  bool get isPending => status == 'pending';
  bool get isActive => status == 'active';

  CoupleMemberEntity? partner(int currentUserId) {
    if (members.length < 2) return null;
    return members.firstWhere(
      (m) => m.userId != currentUserId,
      orElse: () => members.first, // Fallback if no matching partner found
    );
  }

  CoupleMemberEntity? me(int currentUserId) {
    for (final m in members) {
      if (m.userId == currentUserId) {
        return m;
      }
    }
    return null;
  }

  CoupleEntity copyWith({
    int? id,
    String? inviteCode,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CoupleMemberEntity>? members,
    int? currentStreak,
    String? lastActivityDate,
  }) {
    return CoupleEntity(
      id: id ?? this.id,
      inviteCode: inviteCode ?? this.inviteCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      members: members ?? this.members,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }
}
