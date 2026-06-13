import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'couple_member_model.dart';

class CoupleModel {
  final int id;
  final String inviteCode;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CoupleMemberModel> members;

  CoupleModel({
    required this.id,
    required this.inviteCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
  });

  factory CoupleModel.fromJson(Map<String, dynamic> json) {
    var memberList = json['members'] as List? ?? [];
    return CoupleModel(
      id: json['id'] ?? 0,
      inviteCode: json['inviteCode'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      members: memberList.map((m) => CoupleMemberModel.fromJson(m)).toList(),
    );
  }

  CoupleEntity toEntity() {
    return CoupleEntity(
      id: id,
      inviteCode: inviteCode,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      members: members.map((m) => m.toEntity()).toList(),
    );
  }
}
