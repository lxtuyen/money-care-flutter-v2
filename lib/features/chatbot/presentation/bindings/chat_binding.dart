import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/chatbot/data/datasources/chat_remote_datasource.dart';
import 'package:money_care/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:money_care/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final remoteDatasource = ChatRemoteDatasourceImpl(api: apiClient);
    final repository = ChatRepositoryImpl(remoteDatasource: remoteDatasource);

    Get.lazyPut(
      () => ChatController(
        sendToChatbotUseCase: SendToChatbotUseCase(repository),
      ),
      fenix: true,
    );
  }
}


