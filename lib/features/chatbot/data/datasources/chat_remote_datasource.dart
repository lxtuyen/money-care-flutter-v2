import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/chatbot/data/models/chat_model.dart';

abstract class ChatRemoteDatasource {
  Future<String> sendToChatbot(ChatDto dto);
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final ApiClient api;

  ChatRemoteDatasourceImpl({required this.api});

  @override
  Future<String> sendToChatbot(ChatDto dto) async {
    final res = await api.post<String>(
      ApiRoutes.chatbot,
      body: dto.toJson(),
    );
    if (!res.success) throw Exception(res.message);
    return res.message;
  }
}
