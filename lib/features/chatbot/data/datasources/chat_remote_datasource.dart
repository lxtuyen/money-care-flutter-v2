import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/chatbot/data/models/chat_model.dart';

abstract class ChatRemoteDatasource {
  Future<String> sendToChatbot(ChatDto dto, {XFile? file});
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final ApiClient api;

  ChatRemoteDatasourceImpl({required this.api});

  @override
  Future<String> sendToChatbot(ChatDto dto, {XFile? file}) async {
    if (file != null) {
      final res = await api.postMultipart<String>(
        ApiRoutes.chatbot,
        fields: dto.toJson(),
        file: file,
      );
      if (!res.success) throw Exception(res.message);
      return res.message;
    }

    final res = await api.post<String>(
      ApiRoutes.chatbot,
      body: dto.toJson(),
    );
    if (!res.success) throw Exception(res.message);
    return res.message;
  }
}
