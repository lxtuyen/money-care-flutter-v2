class CoupleMessageEntity {
  final int id;
  final int coupleId;
  final int senderId;
  final String content;
  final DateTime createdAt;
  final String? senderName;
  final String? senderAvatar;
  final Map<String, dynamic>? metadata;

  CoupleMessageEntity({
    required this.id,
    required this.coupleId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.senderName,
    this.senderAvatar,
    this.metadata,
  });
}
