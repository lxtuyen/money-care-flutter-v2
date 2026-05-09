class ChatMessageEntity {
  final bool isUser;
  final String text;
  final String? imagePath;
  final Map<String, dynamic>? metadata;

  const ChatMessageEntity({
    required this.isUser,
    required this.text,
    this.imagePath,
    this.metadata,
  });
}
