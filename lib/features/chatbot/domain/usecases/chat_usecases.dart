import 'package:money_care/features/chatbot/data/models/models.dart';
import 'package:money_care/features/chatbot/domain/repositories/chat_repository.dart';

class SendToChatbotUseCase {
  final ChatRepository repository;

  SendToChatbotUseCase(this.repository);

  Future<String> call(ChatDto dto, {String? filePath}) {
    return repository.sendToChatbot(dto, filePath: filePath);
  }
}

