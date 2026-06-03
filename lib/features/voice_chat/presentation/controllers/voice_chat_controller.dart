import 'dart:async';

import 'package:get/get.dart';
import 'package:money_care/features/voice_chat/domain/entities/voice_chat_event.dart';
import 'package:money_care/features/voice_chat/domain/repositories/voice_chat_repository.dart';
import 'package:money_care/features/voice_chat/domain/usecases/voice_chat_usecases.dart';

enum VoiceChatState { idle, connecting, listening, thinking, speaking, error }

class VoiceTranscriptLine {
  final bool isUser;
  final String text;

  const VoiceTranscriptLine({required this.isUser, required this.text});
}

class VoiceChatController extends GetxController {
  final StartVoiceChatUseCase startVoiceChatUseCase;

  VoiceChatController({required this.startVoiceChatUseCase});

  final state = VoiceChatState.idle.obs;
  final errorMessage = RxnString();
  final sessionId = RxnString();
  final transcripts = <VoiceTranscriptLine>[].obs;

  VoiceChatConnection? _connection;
  StreamSubscription<VoiceChatEvent>? _subscription;

  bool get isActive =>
      state.value == VoiceChatState.connecting ||
      state.value == VoiceChatState.listening ||
      state.value == VoiceChatState.thinking ||
      state.value == VoiceChatState.speaking;

  Future<void> toggle(int userId) async {
    if (isActive) {
      await stop();
      return;
    }
    await start(userId);
  }

  Future<void> start(int userId) async {
    if (userId <= 0 || isActive) return;

    try {
      errorMessage.value = null;
      state.value = VoiceChatState.connecting;
      transcripts.clear();

      _connection = await startVoiceChatUseCase(userId: userId);
      _subscription = _connection!.events.listen(_handleEvent);
      await _connection!.startRecording();
    } catch (e) {
      errorMessage.value = e.toString();
      state.value = VoiceChatState.error;
      await _disposeConnection();
    }
  }

  Future<void> stop() async {
    await _connection?.stop();
    await _disposeConnection();
    state.value = VoiceChatState.idle;
  }

  void _handleEvent(VoiceChatEvent event) {
    switch (event.type) {
      case VoiceChatEventType.ready:
        sessionId.value = event.sessionId;
        state.value = VoiceChatState.listening;
        break;
      case VoiceChatEventType.transcript:
        final text = event.text?.trim();
        if (text == null || text.isEmpty) return;
        transcripts.add(
          VoiceTranscriptLine(isUser: event.role == 'user', text: text),
        );
        state.value = event.role == 'user'
            ? VoiceChatState.thinking
            : VoiceChatState.speaking;
        break;
      case VoiceChatEventType.audio:
        state.value = VoiceChatState.speaking;
        break;
      case VoiceChatEventType.error:
        errorMessage.value = event.errorMessage ?? 'Voice chat error.';
        state.value = VoiceChatState.error;
        break;
      case VoiceChatEventType.done:
        if (state.value != VoiceChatState.error) {
          state.value = VoiceChatState.listening;
        }
        break;
    }
  }

  Future<void> _disposeConnection() async {
    await _subscription?.cancel();
    _subscription = null;
    await _connection?.dispose();
    _connection = null;
  }

  @override
  void onClose() {
    _disposeConnection();
    super.onClose();
  }
}
