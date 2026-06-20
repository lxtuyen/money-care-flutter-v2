class ChatDto {
  final String? message;
  final int userId;
  final String? ocrText;
  final String? ocrLines;
  final int? goalId;
  final double? forecastedSaving;

  ChatDto({
    this.message,
    required this.userId,
    this.ocrText,
    this.ocrLines,
    this.goalId,
    this.forecastedSaving,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'ocrText': ocrText,
      'ocrLines': ocrLines,
      if (goalId != null) 'goalId': goalId,
      if (forecastedSaving != null) 'forecastedSaving': forecastedSaving,
    };
  }
}
