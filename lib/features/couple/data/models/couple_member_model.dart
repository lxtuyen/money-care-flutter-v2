import 'package:money_care/features/couple/domain/entities/couple_member_entity.dart';

class CoupleMemberModel {
  final int userId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String role;
  final bool sharePersonalTransactions;
  final bool allowAiShare;
  final DateTime joinedAt;

  CoupleMemberModel({
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

  factory CoupleMemberModel.fromJson(Map<String, dynamic> json) {
    return CoupleMemberModel(
      userId: json['userId'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      role: json['role'] ?? 'owner',
      sharePersonalTransactions: json['sharePersonalTransactions'] ?? false,
      allowAiShare: json['allowAiShare'] ?? false,
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'])
          : DateTime.now(),
    );
  }

  CoupleMemberEntity toEntity() {
    return CoupleMemberEntity(
      userId: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatar: avatar,
      role: role,
      sharePersonalTransactions: sharePersonalTransactions,
      allowAiShare: allowAiShare,
      joinedAt: joinedAt,
    );
  }
}
