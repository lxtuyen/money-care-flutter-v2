import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:get/get.dart';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class SocketService extends GetxService {
  socket_io.Socket? _socket;
  final LocalStorage _storage = Get.find<LocalStorage>();

  socket_io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connectToCoupleChat({
    required int coupleId,
    required Function(Map<String, dynamic>) onMessageReceived,
  }) async {
    if (_socket != null) {
      _socket!.off('receiveMessage');
      _socket!.on('receiveMessage', (data) {
        dev.log("SocketService: Received new message: $data");
        if (data != null) {
          onMessageReceived(Map<String, dynamic>.from(data));
        }
      });
      if (!_socket!.connected) {
        _socket!.connect();
      }
      return;
    }

    final token = _storage.getToken();
    if (token == null) {
      dev.log("SocketService: Cannot connect because token is null");
      return;
    }

    final apiBaseUrl = dotenv.env[kIsWeb ? 'API_LOCALHOST_URL' : 'API_BASE_URL'] ?? 'http://localhost:3000';
    var serverUrl = apiBaseUrl;
    if (serverUrl.endsWith('/api')) {
      serverUrl = serverUrl.substring(0, serverUrl.length - 4);
    } else if (serverUrl.endsWith('/api/')) {
      serverUrl = serverUrl.substring(0, serverUrl.length - 5);
    }

    dev.log("SocketService: Connecting to server: $serverUrl/couple-chat");

    _socket = socket_io.io(
      '$serverUrl/couple-chat',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': 'Bearer $token'})
          .enableForceNew()
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      dev.log("SocketService: Connected to WebSocket couple-chat gateway successfully");
    });

    _socket!.onDisconnect((_) {
      dev.log("SocketService: Disconnected from WebSocket couple-chat gateway");
    });

    _socket!.onConnectError((data) {
      dev.log("SocketService: Connection error: $data");
    });

    _socket!.onError((data) {
      dev.log("SocketService: Error: $data");
    });

    _socket!.on('receiveMessage', (data) {
      dev.log("SocketService: Received new message: $data");
      if (data != null) {
        onMessageReceived(Map<String, dynamic>.from(data));
      }
    });
  }

  void sendMessage(String content, {Map<String, dynamic>? metadata}) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('sendMessage', {
        'content': content,
        'metadata': ?metadata,
      });
    } else {
      dev.log("SocketService: Cannot send message, socket is disconnected");
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      dev.log("SocketService: Disconnected and disposed socket");
    }
  }
}
