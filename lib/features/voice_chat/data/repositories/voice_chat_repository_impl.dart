import 'dart:async';

import 'package:money_care/features/voice_chat/data/datasources/voice_audio_datasource.dart';
import 'package:money_care/features/voice_chat/data/datasources/voice_chat_remote_datasource.dart';
import 'package:money_care/features/voice_chat/domain/entities/voice_chat_event.dart';
import 'package:money_care/features/voice_chat/domain/repositories/voice_chat_repository.dart';

class VoiceChatRepositoryImpl implements VoiceChatRepository {
  final VoiceChatRemoteDatasource remoteDatasource;
  final VoiceAudioDatasource audioDatasource;

  VoiceChatRepositoryImpl({
    required this.remoteDatasource,
    required this.audioDatasource,
  });

  @override
  Future<VoiceChatConnection> connect({
    required int userId,
    String locale = 'vi-VN',
  }) async {
    await remoteDatasource.connect(userId: userId, locale: locale);
    return VoiceChatConnectionImpl(
      remoteDatasource: remoteDatasource,
      audioDatasource: audioDatasource,
    );
  }
}

class VoiceChatConnectionImpl implements VoiceChatConnection {
  final VoiceChatRemoteDatasource remoteDatasource;
  final VoiceAudioDatasource audioDatasource;
  StreamSubscription<VoiceChatEvent>? _audioSubscription;

  VoiceChatConnectionImpl({
    required this.remoteDatasource,
    required this.audioDatasource,
  }) {
    _audioSubscription = remoteDatasource.events.listen((event) {
      if (event.type == VoiceChatEventType.audio &&
          event.audioBase64 != null &&
          event.audioBase64!.isNotEmpty) {
        audioDatasource.playBase64Pcm(event.audioBase64!);
      }
    });
  }

  @override
  Stream<VoiceChatEvent> get events => remoteDatasource.events;

  @override
  Future<void> startRecording() {
    return audioDatasource.startRecording(remoteDatasource.sendAudio);
  }

  @override
  Future<void> stop() async {
    await audioDatasource.stop();
    remoteDatasource.stop();
  }

  @override
  Future<void> dispose() async {
    await _audioSubscription?.cancel();
    await audioDatasource.dispose();
    await remoteDatasource.dispose();
  }
}
