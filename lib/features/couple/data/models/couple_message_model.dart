import 'package:money_care/features/couple/domain/entities/couple_message_entity.dart';

class CoupleMessageModel extends CoupleMessageEntity {
  CoupleMessageModel({
    required super.id,
    required super.coupleId,
    required super.senderId,
    required super.content,
    required super.createdAt,
    super.senderName,
    super.senderAvatar,
    super.metadata,
  });

  factory CoupleMessageModel.fromJson(Map<String, dynamic> json) {
    String? name;
    String? avatar;
    if (json['sender'] != null) {
      final sender = json['sender'] as Map<String, dynamic>;
      if (sender['profile'] != null) {
        final profile = sender['profile'] as Map<String, dynamic>;
        final fName = profile['first_name'] as String? ?? '';
        final lName = profile['last_name'] as String? ?? '';
        name = '$fName $lName'.trim();
        if (name.isEmpty) {
          name = sender['email'] as String? ?? '';
        }
        avatar = profile['avatar'] as String?;
      }
    }

    DateTime parsedDate = DateTime.now();
    if (json['createdAt'] != null) {
      final rawDate = json['createdAt'];
      if (rawDate is String) {
        var dateStr = rawDate;
        if (!dateStr.endsWith('Z') && !dateStr.contains('+')) {
          bool hasNegativeOffset = false;
          if (dateStr.length > 6) {
            final suffix = dateStr.substring(dateStr.length - 6);
            if (suffix.contains('-')) {
              hasNegativeOffset = true;
            }
          }
          if (!hasNegativeOffset) {
            dateStr = '${dateStr}Z';
          }
        }
        parsedDate = DateTime.parse(dateStr).toLocal();
      } else if (rawDate is DateTime) {
        parsedDate = rawDate.toLocal();
      }
    }

    return CoupleMessageModel(
      id: json['id'] ?? 0,
      coupleId: json['coupleId'] ?? 0,
      senderId: json['senderId'] ?? 0,
      content: json['content'] ?? '',
      createdAt: parsedDate,
      senderName: name,
      senderAvatar: avatar,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coupleId': coupleId,
      'senderId': senderId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}
