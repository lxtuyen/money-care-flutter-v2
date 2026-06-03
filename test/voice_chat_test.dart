import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:money_care/features/chatbot/presentation/bindings/chat_binding.dart';
import 'package:money_care/features/chatbot/presentation/screens/chatbot.dart';
import 'package:money_care/features/voice_chat/data/datasources/voice_audio_datasource.dart';
import 'package:money_care/features/voice_chat/data/datasources/voice_chat_remote_datasource.dart';
import 'package:money_care/features/voice_chat/data/models/voice_chat_event_model.dart';
import 'package:money_care/features/voice_chat/data/repositories/voice_chat_repository_impl.dart';
import 'package:money_care/features/voice_chat/domain/entities/voice_chat_event.dart';
import 'package:money_care/features/voice_chat/domain/repositories/voice_chat_repository.dart';
import 'package:money_care/features/voice_chat/domain/usecases/voice_chat_usecases.dart';
import 'package:money_care/features/voice_chat/presentation/controllers/voice_chat_controller.dart';
import 'package:money_care/features/voice_chat/presentation/widgets/voice_chat_panel.dart';

void main() {
  test('parses ready, transcript, audio, error, and done messages', () {
    expect(
      VoiceChatEventModel.fromJson({
        'type': 'ready',
        'sessionId': 'session-1',
      }).sessionId,
      'session-1',
    );

    final transcript = VoiceChatEventModel.fromJson({
      'type': 'transcript',
      'role': 'model',
      'text': 'Xin chào',
      'final': true,
    });
    expect(transcript.type, VoiceChatEventType.transcript);
    expect(transcript.role, 'model');
    expect(transcript.finalTranscript, true);

    expect(
      VoiceChatEventModel.fromJson({
        'type': 'audio',
        'data': 'abc',
      }).audioBase64,
      'abc',
    );
    expect(
      VoiceChatEventModel.fromJson({'type': 'error', 'message': 'Lỗi'}).type,
      VoiceChatEventType.error,
    );
    expect(
      VoiceChatEventModel.fromJson({'type': 'done'}).type,
      VoiceChatEventType.done,
    );
  });

  test('controller transitions through voice states', () async {
    final repository = _FakeVoiceChatRepository();
    final controller = VoiceChatController(
      startVoiceChatUseCase: StartVoiceChatUseCase(repository),
    );

    await controller.start(1);
    expect(controller.state.value, VoiceChatState.connecting);

    repository.connection.add(
      const VoiceChatEvent(type: VoiceChatEventType.ready, sessionId: 's1'),
    );
    await Future<void>.delayed(Duration.zero);
    expect(controller.state.value, VoiceChatState.listening);

    repository.connection.add(
      const VoiceChatEvent(
        type: VoiceChatEventType.transcript,
        role: 'model',
        text: 'Tôi có thể giúp gì?',
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(controller.state.value, VoiceChatState.speaking);

    await controller.stop();
    expect(controller.state.value, VoiceChatState.idle);
  });

  test('voice feature public classes are available', () {
    expect(VoiceAudioDatasource, isNotNull);
    expect(VoiceChatRemoteDatasource, isNotNull);
    expect(VoiceChatRepositoryImpl, isNotNull);
    expect(VoiceChatPanel, isNotNull);
    expect(ChatBinding, isNotNull);
    expect(ChatbotScreen, isNotNull);
  });
}

class _FakeVoiceChatRepository implements VoiceChatRepository {
  final _FakeVoiceChatConnection connection = _FakeVoiceChatConnection();

  @override
  Future<VoiceChatConnection> connect({
    required int userId,
    String locale = 'vi-VN',
  }) async {
    return connection;
  }
}

class _FakeVoiceChatConnection implements VoiceChatConnection {
  final StreamController<VoiceChatEvent> _events =
      StreamController<VoiceChatEvent>.broadcast();

  void add(VoiceChatEvent event) => _events.add(event);

  @override
  Stream<VoiceChatEvent> get events => _events.stream;

  @override
  Future<void> dispose() async {
    await _events.close();
  }

  @override
  Future<void> startRecording() async {}

  @override
  Future<void> stop() async {}
}
