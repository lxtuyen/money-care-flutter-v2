import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class VoiceAudioDatasource {
  Future<void> open();

  Future<void> startRecording(void Function(Uint8List chunk) onChunk);

  Future<void> playBase64Pcm(String base64Audio);

  Future<void> stop();

  Future<void> dispose();
}

class VoiceAudioDatasourceImpl implements VoiceAudioDatasource {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder(
    logLevel: Level.warning,
  );
  final FlutterSoundPlayer _player = FlutterSoundPlayer(
    logLevel: Level.warning,
  );
  StreamController<Uint8List>? _recordingController;
  bool _opened = false;
  bool _playerStarted = false;

  @override
  Future<void> open() async {
    if (_opened) return;
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Bạn cần cấp quyền microphone để nói chuyện với AI.');
    }

    await _recorder.openRecorder();
    await _player.openPlayer();
    await _player.startPlayerFromStream(
      codec: Codec.pcm16,
      interleaved: true,
      numChannels: 1,
      sampleRate: 24000,
      bufferSize: 8192,
    );
    _playerStarted = true;
    _opened = true;
  }

  @override
  Future<void> startRecording(void Function(Uint8List chunk) onChunk) async {
    await open();
    await _recordingController?.close();
    _recordingController = StreamController<Uint8List>();
    _recordingController!.stream.listen(onChunk);

    await _recorder.startRecorder(
      codec: Codec.pcm16,
      sampleRate: 16000,
      numChannels: 1,
      audioSource: AudioSource.microphone,
      toStream: _recordingController!.sink,
      bufferSize: 8192,
      enableNoiseSuppression: true,
      enableEchoCancellation: true,
    );
  }

  @override
  Future<void> playBase64Pcm(String base64Audio) async {
    await open();
    if (!_playerStarted) {
      await _player.startPlayerFromStream(
        codec: Codec.pcm16,
        interleaved: true,
        numChannels: 1,
        sampleRate: 24000,
        bufferSize: 8192,
      );
      _playerStarted = true;
    }
    await _player.feedUint8FromStream(base64Decode(base64Audio));
  }

  @override
  Future<void> stop() async {
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
    await _recordingController?.close();
    _recordingController = null;
  }

  @override
  Future<void> dispose() async {
    await stop();
    if (_playerStarted) {
      await _player.stopPlayer();
      _playerStarted = false;
    }
    if (_opened) {
      await _recorder.closeRecorder();
      await _player.closePlayer();
      _opened = false;
    }
  }
}
