class ChatDto {
  final String message;
  final int userId;
  final int? goalId;

  ChatDto({
    required this.message,
    required this.userId,
    this.goalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      if (goalId != null) 'goalId': goalId,
    };
  }
}


