class ChatDto {
  final String? message;
  final int userId;
  final String? ocrText;
  final String? ocrLines;
  final double? latitude;
  final double? longitude;

  ChatDto({
    this.message,
    required this.userId,
    this.ocrText,
    this.ocrLines,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'ocrText': ocrText,
      'ocrLines': ocrLines,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
