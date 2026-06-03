import 'dart:async';
import 'dart:convert';

import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/voice_chat/data/models/voice_chat_event_model.dart';
import 'package:money_care/features/voice_chat/domain/entities/voice_chat_event.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class VoiceChatRemoteDatasource {
  Stream<VoiceChatEvent> get events;

  Future<void> connect({required int userId, String locale = 'vi-VN'});

  void sendAudio(List<int> pcmBytes);

  void stop();

  Future<void> dispose();
}

class VoiceChatRemoteDatasourceImpl implements VoiceChatRemoteDatasource {
  final ApiClient api;
  final LocalStorage storage;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final StreamController<VoiceChatEvent> _events =
      StreamController<VoiceChatEvent>.broadcast();

  VoiceChatRemoteDatasourceImpl({required this.api, required this.storage});

  @override
  Stream<VoiceChatEvent> get events => _events.stream;

  @override
  Future<void> connect({required int userId, String locale = 'vi-VN'}) async {
    final uri = _buildVoiceUri();
    _channel = WebSocketChannel.connect(uri);

    _subscription = _channel!.stream.listen(
      (message) {
        if (message is! String) return;
        try {
          final decoded = jsonDecode(message);
          if (decoded is Map<String, dynamic>) {
            _events.add(VoiceChatEventModel.fromJson(decoded));
          }
        } catch (_) {
          _events.add(
            const VoiceChatEvent(
              type: VoiceChatEventType.error,
              errorCode: 'INVALID_SERVER_MESSAGE',
              errorMessage: 'Không đọc được phản hồi voice.',
            ),
          );
        }
      },
      onError: (error) {
        _events.add(
          VoiceChatEvent(
            type: VoiceChatEventType.error,
            errorCode: 'VOICE_SOCKET_ERROR',
            errorMessage: error.toString(),
          ),
        );
      },
      onDone: () {
        _events.add(const VoiceChatEvent(type: VoiceChatEventType.done));
      },
    );

    _channel!.sink.add(
      jsonEncode({'type': 'start', 'userId': userId, 'locale': locale}),
    );
  }

  @override
  void sendAudio(List<int> pcmBytes) {
    if (pcmBytes.isEmpty) return;
    _channel?.sink.add(
      jsonEncode({
        'type': 'audio',
        'mimeType': 'audio/pcm;rate=16000',
        'data': base64Encode(pcmBytes),
      }),
    );
  }

  @override
  void stop() {
    _channel?.sink.add(jsonEncode({'type': 'stop'}));
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    await _events.close();
  }

  Uri _buildVoiceUri() {
    final base = Uri.parse(api.baseUrl);
    final scheme = base.scheme == 'https' ? 'wss' : 'ws';
    final path = [
      if (base.path.trim().isNotEmpty) base.path.replaceAll(RegExp(r'^/+'), ''),
      'ai/voice/live',
    ].join('/');
    final token = storage.getToken();

    return base.replace(
      scheme: scheme,
      path: path,
      queryParameters: token == null || token.isEmpty ? null : {'token': token},
    );
  }
}
