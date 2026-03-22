class ChatDto {
  final String message;
  final int userId;

  ChatDto({
    required this.message,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
    };
  }
}
