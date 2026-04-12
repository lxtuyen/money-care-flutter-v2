class ChatDto {
  final String message;
  final int userId;
  final int? fundId;

  ChatDto({
    required this.message,
    required this.userId,
    this.fundId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      if (fundId != null) 'fundId': fundId,
    };
  }
}
