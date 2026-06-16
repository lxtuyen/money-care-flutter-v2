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
    required Function(Map<String, dynamic>) onMessageUpdated,
    required Function(int) onMessageDeleted,
    required Function(Map<String, dynamic>) onStreakUpdated,
  }) async {
    if (_socket != null) {
      _socket!.off('receiveMessage');
      _socket!.on('receiveMessage', (data) {
        dev.log("SocketService: Received new message: $data");
        if (data != null) {
          onMessageReceived(Map<String, dynamic>.from(data));
        }
      });
      _socket!.off('messageUpdated');
      _socket!.on('messageUpdated', (data) {
        dev.log("SocketService: Message updated: $data");
        if (data != null) {
          onMessageUpdated(Map<String, dynamic>.from(data));
        }
      });
      _socket!.off('messageDeleted');
      _socket!.on('messageDeleted', (data) {
        dev.log("SocketService: Message deleted: $data");
        if (data != null && data['id'] != null) {
          final id = int.tryParse(data['id'].toString()) ?? 
                     (data['id'] is num ? (data['id'] as num).toInt() : 0);
          if (id > 0) {
            onMessageDeleted(id);
          }
        }
      });
      _socket!.off('streakUpdated');
      _socket!.on('streakUpdated', (data) {
        dev.log("SocketService: Streak updated: $data");
        if (data != null) {
          onStreakUpdated(Map<String, dynamic>.from(data));
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
    if (serverUrl.endsWith('/')) {
      serverUrl = serverUrl.substring(0, serverUrl.length - 1);
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

    _socket!.on('messageUpdated', (data) {
      dev.log("SocketService: Message updated: $data");
      if (data != null) {
        onMessageUpdated(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('messageDeleted', (data) {
      dev.log("SocketService: Message deleted: $data");
      if (data != null && data['id'] != null) {
        final id = int.tryParse(data['id'].toString()) ?? 
                   (data['id'] is num ? (data['id'] as num).toInt() : 0);
        if (id > 0) {
          onMessageDeleted(id);
        }
      }
    });

    _socket!.on('streakUpdated', (data) {
      dev.log("SocketService: Streak updated: $data");
      if (data != null) {
        onStreakUpdated(Map<String, dynamic>.from(data));
      }
    });
  }

  void sendMessage(String content, {Map<String, dynamic>? metadata}) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('sendMessage', {
        'content': content,
        'metadata': metadata,
      });
    } else {
      dev.log("SocketService: Cannot send message, socket is disconnected");
    }
  }

  void updateMessage(int messageId, String content) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('editMessage', {
        'id': messageId,
        'content': content,
      });
    } else {
      dev.log("SocketService: Cannot edit message, socket is disconnected");
    }
  }

  void deleteMessage(int messageId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('deleteMessage', {
        'id': messageId,
      });
    } else {
      dev.log("SocketService: Cannot delete message, socket is disconnected");
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
