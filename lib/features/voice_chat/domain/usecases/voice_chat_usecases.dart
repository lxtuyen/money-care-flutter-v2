import 'package:money_care/features/voice_chat/domain/repositories/voice_chat_repository.dart';

class StartVoiceChatUseCase {
  final VoiceChatRepository repository;

  StartVoiceChatUseCase(this.repository);

  Future<VoiceChatConnection> call({
    required int userId,
    String locale = 'vi-VN',
  }) {
    return repository.connect(userId: userId, locale: locale);
  }
}
