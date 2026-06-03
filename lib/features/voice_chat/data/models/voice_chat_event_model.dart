import 'package:money_care/features/voice_chat/domain/entities/voice_chat_event.dart';

class VoiceChatEventModel extends VoiceChatEvent {
  const VoiceChatEventModel({
    required super.type,
    super.sessionId,
    super.role,
    super.text,
    super.finalTranscript,
    super.audioBase64,
    super.errorCode,
    super.errorMessage,
  });

  factory VoiceChatEventModel.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'ready':
        return VoiceChatEventModel(
          type: VoiceChatEventType.ready,
          sessionId: json['sessionId']?.toString(),
        );
      case 'transcript':
        return VoiceChatEventModel(
          type: VoiceChatEventType.transcript,
          role: json['role']?.toString(),
          text: json['text']?.toString(),
          finalTranscript: json['final'] == true,
        );
      case 'audio':
        return VoiceChatEventModel(
          type: VoiceChatEventType.audio,
          audioBase64: json['data']?.toString(),
        );
      case 'error':
        return VoiceChatEventModel(
          type: VoiceChatEventType.error,
          errorCode: json['code']?.toString(),
          errorMessage: json['message']?.toString(),
        );
      case 'done':
        return const VoiceChatEventModel(type: VoiceChatEventType.done);
      default:
        return VoiceChatEventModel(
          type: VoiceChatEventType.error,
          errorCode: 'UNKNOWN_SERVER_MESSAGE',
          errorMessage: 'Không nhận diện được phản hồi voice.',
        );
    }
  }
}
