import 'couple_member_entity.dart';

class CoupleEntity {
  final int id;
  final String inviteCode;
  final String status; // 'pending' | 'active' | 'cancelled' | 'left'
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CoupleMemberEntity> members;

  const CoupleEntity({
    required this.id,
    required this.inviteCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
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
}
