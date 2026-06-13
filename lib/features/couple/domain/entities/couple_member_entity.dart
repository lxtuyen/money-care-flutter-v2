class CoupleMemberEntity {
  final int userId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String role; // 'owner' | 'partner'
  final bool sharePersonalTransactions;
  final bool allowAiShare;
  final DateTime joinedAt;

  const CoupleMemberEntity({
    required this.userId,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    required this.role,
    required this.sharePersonalTransactions,
    required this.allowAiShare,
    required this.joinedAt,
  });

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final combined = '$first $last'.trim();
    return combined.isNotEmpty ? combined : email;
  }

  String get initials {
    final first = firstName ?? '';
    final last = lastName ?? '';
    if (first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    }
    if (fullName.isNotEmpty) {
      return fullName[0].toUpperCase();
    }
    return '?';
  }
}
