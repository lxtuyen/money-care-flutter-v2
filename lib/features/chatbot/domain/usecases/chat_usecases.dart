import 'package:money_care/features/chatbot/data/models/chat_model.dart';
import 'package:money_care/features/chatbot/domain/repositories/chat_repository.dart';

class SendToChatbotUseCase {
  final ChatRepository repository;

  SendToChatbotUseCase(this.repository);

  Future<String> call(ChatDto dto) {
    return repository.sendToChatbot(dto);
  }
}
