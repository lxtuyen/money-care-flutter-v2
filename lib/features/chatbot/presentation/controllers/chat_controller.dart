import 'package:get/get.dart';
import 'package:money_care/features/chatbot/data/models/chat_model.dart';
import 'package:money_care/features/chatbot/domain/entities/chat_entity.dart';
import 'package:money_care/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';

class ChatController extends GetxController {
  final SendToChatbotUseCase sendToChatbotUseCase;

  ChatController({required this.sendToChatbotUseCase});

  final isLoading = false.obs;
  final errorMessage = RxnString();

  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;
  final TransactionController transactionController =
      Get.find<TransactionController>();

  Future<String> send(String text, int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final dto = ChatDto(message: text, userId: userId);
      final reply = await sendToChatbotUseCase(dto);

      try {
        await transactionController.refreshAllData(userId);
      } catch (_) {
      }

      return reply;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void addUserMessage(String text) {
    messages.add(ChatMessageEntity(isUser: true, text: text));
  }

  void addBotMessage(String text) {
    messages.add(ChatMessageEntity(isUser: false, text: text));
  }

  void replaceLastBotMessage(String text) {
    if (messages.isNotEmpty) {
      messages[messages.length - 1] =
          ChatMessageEntity(isUser: false, text: text);
    }
  }

  void clear() => messages.clear();
}
