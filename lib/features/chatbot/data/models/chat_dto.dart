class ChatDto {
  final String? message;
  final int userId;
  final String? ocrText;
  final String? ocrLines;

  ChatDto({this.message, required this.userId, this.ocrText, this.ocrLines});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'ocrText': ocrText,
      'ocrLines': ocrLines,
    };
  }
}
