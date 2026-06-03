enum VoiceChatEventType { ready, transcript, audio, error, done }

class VoiceChatEvent {
  final VoiceChatEventType type;
  final String? sessionId;
  final String? role;
  final String? text;
  final bool finalTranscript;
  final String? audioBase64;
  final String? errorCode;
  final String? errorMessage;

  const VoiceChatEvent({
    required this.type,
    this.sessionId,
    this.role,
    this.text,
    this.finalTranscript = false,
    this.audioBase64,
    this.errorCode,
    this.errorMessage,
  });
}
