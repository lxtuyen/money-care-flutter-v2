import 'package:money_care/features/chatbot/data/models/chat_model.dart';

abstract class ChatRepository {
  Future<String> sendToChatbot(ChatDto dto);
}
