import 'package:money_care/features/chatbot/data/models/models.dart';

abstract class ChatRepository {
  Future<String> sendToChatbot(ChatDto dto, {String? filePath});
}



