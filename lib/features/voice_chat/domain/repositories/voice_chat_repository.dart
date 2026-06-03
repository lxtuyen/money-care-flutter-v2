import 'package:money_care/features/voice_chat/domain/entities/voice_chat_event.dart';

abstract class VoiceChatConnection {
  Stream<VoiceChatEvent> get events;

  Future<void> startRecording();

  Future<void> stop();

  Future<void> dispose();
}

abstract class VoiceChatRepository {
  Future<VoiceChatConnection> connect({
    required int userId,
    String locale = 'vi-VN',
  });
}
