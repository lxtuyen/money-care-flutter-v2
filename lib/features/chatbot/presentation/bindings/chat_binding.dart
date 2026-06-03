import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/chatbot/data/datasources/chat_remote_datasource.dart';
import 'package:money_care/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:money_care/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/voice_chat/data/datasources/voice_audio_datasource.dart';
import 'package:money_care/features/voice_chat/data/datasources/voice_chat_remote_datasource.dart';
import 'package:money_care/features/voice_chat/data/repositories/voice_chat_repository_impl.dart';
import 'package:money_care/features/voice_chat/domain/usecases/voice_chat_usecases.dart';
import 'package:money_care/features/voice_chat/presentation/controllers/voice_chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final remoteDatasource = ChatRemoteDatasourceImpl(api: apiClient);
    final repository = ChatRepositoryImpl(remoteDatasource: remoteDatasource);
    final voiceRemoteDatasource = VoiceChatRemoteDatasourceImpl(
      api: apiClient,
      storage: Get.find<LocalStorage>(),
    );
    final voiceRepository = VoiceChatRepositoryImpl(
      remoteDatasource: voiceRemoteDatasource,
      audioDatasource: VoiceAudioDatasourceImpl(),
    );

    Get.lazyPut(
      () => ChatController(
        sendToChatbotUseCase: SendToChatbotUseCase(repository),
        filterTransactionsUseCase: Get.find<FilterTransactionsUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => VoiceChatController(
        startVoiceChatUseCase: StartVoiceChatUseCase(voiceRepository),
      ),
      fenix: true,
    );
  }
}
