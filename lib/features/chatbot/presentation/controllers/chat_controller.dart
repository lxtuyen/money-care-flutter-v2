import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:money_care/features/chatbot/data/models/models.dart';
import 'package:money_care/features/chatbot/domain/entities/chat_entity.dart';
import 'package:money_care/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatController extends GetxController {
  final SendToChatbotUseCase sendToChatbotUseCase;

  ChatController({required this.sendToChatbotUseCase});

  final AppController appController = Get.find<AppController>();
  final SavingGoalController savingGoalController = Get.find<SavingGoalController>();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;

  final List<Map<String, dynamic>> options = const [
    {
      'title': '📊 Phân tích chi tiêu',
      'desc': 'Nhận nhận xét và lời khuyên tiết kiệm dựa trên chi tiêu thực tế.',
      'template': 'Phân tích chi tiêu gần đây của tôi và cho tôi lời khuyên tiết kiệm.',
    },
    {
      'title': '🎯 Gợi ý ngân sách',
      'desc': 'AI sẽ giúp bạn lên kế hoạch ngân sách thông minh cho tháng tới.',
      'template': 'Hãy gợi ý cho tôi một kế hoạch ngân sách dựa trên thói quen chi tiêu của tôi.',
    },
    {
      'title': '📝 Ghi nhanh chi tiêu',
      'desc': 'Ghi chép cực nhanh: "bún bò 35k sáng nay", "đổ xăng 50k"...',
      'template': 'ăn sáng 35k hôm nay',
    },
  ];

  final stt.SpeechToText _speech = stt.SpeechToText();
  final isSpeechAvailable = false.obs;
  final isListening = false.obs;

  final TransactionController transactionController =
      Get.find<TransactionController>();

  @override
  void onInit() {
    super.onInit();
    initSpeech();
  }

  Future<void> initSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
        onError: (err) {
          isListening.value = false;
        },
      );
      isSpeechAvailable.value = available;
    } catch (_) {
      isSpeechAvailable.value = false;
    }
  }

  Future<void> toggleListening() async {
    if (!isSpeechAvailable.value) return;

    if (isListening.value) {
      await _speech.stop();
      isListening.value = false;
    } else {
      isListening.value = true;
      await _speech.listen(
        localeId: 'vi_VN',
        onResult: (result) {
          textController.text = result.recognizedWords;
          textController.selection = TextSelection.fromPosition(
            TextPosition(offset: textController.text.length),
          );
        },
      );
    }
  }

  void fillTemplate(String text) {
    textController.text = text;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
  }

  Future<void> sendTemplate(String text, int userId) async {
    fillTemplate(text);
    await send(userId);
  }

  Future<void> send(int userId) async {
    final text = textController.text.trim();
    if (text.isEmpty || isLoading.value) return;

    try {
      textController.clear();
      addUserMessage(text);
      addBotMessage('...');
      scrollToBottom();

      isLoading.value = true;
      errorMessage.value = null;

      final dto = ChatDto(
        message: text,
        userId: userId,
      );
      final reply = await sendToChatbotUseCase(dto);

      if (reply.startsWith('__STRUCTURED_ANALYSIS__')) {
        final jsonStr = reply.replaceFirst('__STRUCTURED_ANALYSIS__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          final summary = data['summary'] ?? 'Phân tích tài chính';
          replaceLastBotMessageWithMetadata(summary, data);
        } catch (e) {
          replaceLastBotMessage(reply.replaceFirst('__STRUCTURED_ANALYSIS__', ''));
        }
      } else if (reply.startsWith('__STRUCTURED_RECEIPT__')) {
        final jsonStr = reply.replaceFirst('__STRUCTURED_RECEIPT__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          replaceLastBotMessageWithMetadata('Tôi đã nhận diện được các mục sau từ hóa đơn:', data);
        } catch (e) {
          replaceLastBotMessage('Tôi đã nhận diện được hóa đơn nhưng gặp lỗi khi hiển thị chi tiết.');
        }
      } else if (reply.startsWith('__TRANSACTION_SAVED__')) {
        final jsonStr = reply.replaceFirst('__TRANSACTION_SAVED__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          data['__type'] = 'transaction_saved';
          replaceLastBotMessageWithMetadata('', data);
        } catch (e) {
          replaceLastBotMessage('✅ Đã ghi nhận giao dịch thành công!');
        }
        try {
          await transactionController.refreshAllData(userId);
          if (Get.isRegistered<GamificationController>()) {
            Future.delayed(const Duration(milliseconds: 300), () {
              Get.find<GamificationController>().recordDailyTransaction();
            });
          }
        } catch (_) {}
      } else {
        replaceLastBotMessage(reply);
      }
      scrollToBottom();
    } catch (e) {
      errorMessage.value = e.toString();
      replaceLastBotMessage('Lỗi kết nối: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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

  void replaceLastBotMessageWithMetadata(String text, Map<String, dynamic> metadata) {
    if (messages.isNotEmpty) {
      messages[messages.length - 1] =
          ChatMessageEntity(isUser: false, text: text, metadata: metadata);
    }
  }

  Future<void> pickAndSendImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    messages.add(ChatMessageEntity(isUser: true, text: "[Hình ảnh hóa đơn]"));
    messages.add(ChatMessageEntity(isUser: false, text: "Đang quét hóa đơn..."));
    scrollToBottom();

    try {
      final userId = await appController.getCurrentUserId();
      if (userId == null) return;

      final dto = ChatDto(
        message: "Quét hóa đơn",
        userId: userId,
      );
      final reply = await sendToChatbotUseCase(dto, filePath: image.path);

      if (reply.startsWith('__STRUCTURED_RECEIPT__')) {
        final jsonStr = reply.replaceFirst('__STRUCTURED_RECEIPT__', '');
        final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
        replaceLastBotMessageWithMetadata('Tôi đã nhận diện được các mục sau từ hóa đơn:', data);
      } else {
        replaceLastBotMessage(reply);
      }
    } catch (e) {
      replaceLastBotMessage("Lỗi khi quét hóa đơn: ${e.toString()}");
    }
    scrollToBottom();
  }

  Future<void> saveReceiptItems(List items) async {
    if (isLoading.value || items.isEmpty) return;
    
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;

    try {
      isLoading.value = true;
      final apiClient = Get.find<ApiClient>();
      
      final response = await apiClient.post('/ai/chat/bulk-save', body: {
        'userId': userId,
        'items': items,
      });

      if (response.success) {
        addBotMessage('✅ Đã lưu tất cả các mục vào lịch sử chi tiêu của bạn!');
        await transactionController.refreshAllData(userId);
        if (Get.isRegistered<GamificationController>()) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.find<GamificationController>().recordDailyTransaction();
          });
        }
      } else {
        addBotMessage('❌ Không thể lưu một số mục. Vui lòng thử lại.');
      }
    } catch (e) {
      addBotMessage('❌ Lỗi khi lưu: ${e.toString()}');
    } finally {
      isLoading.value = false;
      scrollToBottom();
    }
  }

  void clear() => messages.clear();

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _speech.stop();
    super.onClose();
  }
}


