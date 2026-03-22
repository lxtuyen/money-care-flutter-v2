import 'package:money_care/features/chatbot/domain/entities/chat_entity.dart';

class ChatMessageModel {
  final bool isUser;
  final String text;

  ChatMessageModel({
    required this.isUser,
    required this.text,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      isUser: json['isUser'] ?? false,
      text: json['text'] ?? '',
    );
  }

  ChatMessageEntity toEntity() => ChatMessageEntity(
    isUser: isUser,
    text: text,
  );
}
