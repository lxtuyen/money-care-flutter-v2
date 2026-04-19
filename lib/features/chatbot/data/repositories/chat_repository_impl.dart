import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/chatbot/data/datasources/chat_remote_datasource.dart';
import 'package:money_care/features/chatbot/data/models/models.dart';
import 'package:money_care/features/chatbot/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl({required this.remoteDatasource});

  @override
  Future<String> sendToChatbot(ChatDto dto, {String? filePath}) {
    return remoteDatasource.sendToChatbot(
      dto,
      file: filePath != null ? XFile(filePath) : null,
    );
  }
}



