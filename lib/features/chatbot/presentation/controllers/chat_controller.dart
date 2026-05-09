import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:money_care/features/chatbot/data/models/models.dart';

import 'package:money_care/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/services/ocr_service.dart';
import 'package:money_care/features/transaction/data/utils/receipt_parser.dart';

class ChatController extends GetxController {
  final SendToChatbotUseCase sendToChatbotUseCase;

  ChatController({required this.sendToChatbotUseCase});

  final AppController appController = Get.find<AppController>();
  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;

  final OCRService _ocrService = OCRService();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> get options => [
    {
      'title': 'chatbot.analysisTitle'.tr,
      'desc': 'chatbot.analysisDesc'.tr,
      'template': 'chatbot.analysisTemplate'.tr,
    },
    {
      'title': 'chatbot.budgetTitle'.tr,
      'desc': 'chatbot.budgetDesc'.tr,
      'template': 'chatbot.budgetTemplate'.tr,
    },
    {
      'title': 'chatbot.quickRecordTitle'.tr,
      'desc': 'chatbot.quickRecordDesc'.tr,
      'template': 'chatbot.quickRecordTemplate'.tr,
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

  Future<void> pickAndScanReceipt(int userId) async {
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Chụp ảnh hóa đơn'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Chọn từ thư viện'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image == null) return;

    try {
      isLoading.value = true;
      addUserMessage('chatbot.sendingReceipt'.tr, imagePath: image.path); 
      addBotMessage('...');
      scrollToBottom();

      final recognizedText = await _ocrService.processImage(image.path);
      
      // LOG OCR RESULTS
      print('========== OCR RAW TEXT ==========');
      print(recognizedText.text);
      print('==================================');

      final lines = ReceiptParser.extractLines(recognizedText);
      print('Extracted ${lines.length} lines for AI refinement');
      for (var i = 0; i < lines.length; i++) {
        print('Line $i: ${lines[i].text} (x: ${lines[i].x}, y: ${lines[i].y})');
      }

      final ocrText = recognizedText.text;
      final ocrLinesJson = jsonEncode(lines.map((l) => l.toJson()).toList());

      await send(userId, ocrText: ocrText, ocrLines: ocrLinesJson);
    } catch (e) {
      errorMessage.value = e.toString();
      replaceLastBotMessage('Lỗi xử lý hóa đơn: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> send(int userId, {String? ocrText, String? ocrLines}) async {
    final text = textController.text.trim();
    final isOcr = ocrText != null;
    
    // Prevent double sending for text messages, but allow OCR flow which already managed isLoading
    if (!isOcr && (text.isEmpty || isLoading.value)) return;
    if (isOcr && ocrText.isEmpty) return;

    try {
      if (ocrText == null) {
        textController.clear();
        addUserMessage(text);
        addBotMessage('...');
        scrollToBottom();
      }

      isLoading.value = true;
      errorMessage.value = null;

      final dto = ChatDto(
        message: text.isNotEmpty ? text : null,
        userId: userId,
        ocrText: ocrText,
        ocrLines: ocrLines,
      );
      final reply = await sendToChatbotUseCase(dto);

      if (reply.startsWith('__STRUCTURED_ANALYSIS__')) {
        final jsonStr = reply.replaceFirst('__STRUCTURED_ANALYSIS__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          final summary = data['summary'] ?? 'chatbot.financialAnalysis'.tr;
          replaceLastBotMessageWithMetadata(summary, data);
        } catch (e) {
          replaceLastBotMessage(
            reply.replaceFirst('__STRUCTURED_ANALYSIS__', ''),
          );
        }

      } else if (reply.startsWith('__TRANSACTION_SAVED__')) {
        final jsonStr = reply.replaceFirst('__TRANSACTION_SAVED__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          data['__type'] = 'transaction_saved';
          replaceLastBotMessageWithMetadata('', data);
        } catch (e) {
          replaceLastBotMessage('chatbot.transactionSaved'.tr);
        }
        try {
          await transactionController.refreshAllData(userId);
          
          // Refresh Wallet balances
          if (Get.isRegistered<WalletController>()) {
            Get.find<WalletController>().refreshWallets();
          }

          // Refresh current Saving Goal progress
          if (savingGoalController.goalId.value > 0) {
            savingGoalController.loadGoalById();
          }

          // Refresh Statistics
          if (Get.isRegistered<StatisticsController>()) {
            Get.find<StatisticsController>().refreshStatisticsData(userId);
          }

          if (Get.isRegistered<GamificationController>()) {
            Future.delayed(const Duration(milliseconds: 300), () {
              Get.find<GamificationController>().recordDailyTransaction();
            });
          }
        } catch (_) {}
      } else if (reply.startsWith('__TRANSACTION_LIST__')) {
        final jsonStr = reply.replaceFirst('__TRANSACTION_LIST__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          data['__type'] = 'transaction_list';
          replaceLastBotMessageWithMetadata('', data);
        } catch (e) {
          replaceLastBotMessage('chatbot.transactionListError'.tr);
        }
      } else if (reply.startsWith('__CATEGORY_LIST__')) {
        final jsonStr = reply.replaceFirst('__CATEGORY_LIST__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          data['__type'] = 'category_list';
          replaceLastBotMessageWithMetadata('', data);
        } catch (e) {
          replaceLastBotMessage('chatbot.categoryListError'.tr);
        }
      } else if (reply.startsWith('__CATEGORY_CREATED__')) {
        final jsonStr = reply.replaceFirst('__CATEGORY_CREATED__', '');
        try {
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
          data['__type'] = 'category_created';
          replaceLastBotMessageWithMetadata('', data);

          // Refresh categories and statistics in the app
          if (Get.isRegistered<UserCategoryController>()) {
            Get.find<UserCategoryController>().loadCategories(userId);
          }
          if (Get.isRegistered<StatisticsController>()) {
            Get.find<StatisticsController>().refreshStatisticsData(userId);
          }
        } catch (e) {
          replaceLastBotMessage('chatbot.categoryCreated'.tr);
        }
      } else {
        replaceLastBotMessage(reply);
      }
      scrollToBottom();
    } catch (e) {
      errorMessage.value = e.toString();
      replaceLastBotMessage('chatbot.connectionError'.tr.replaceAll('@error', e.toString()));
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

  void addUserMessage(String text, {String? imagePath}) {
    messages.add(ChatMessageEntity(isUser: true, text: text, imagePath: imagePath));
  }

  void addBotMessage(String text) {
    messages.add(ChatMessageEntity(isUser: false, text: text));
  }

  void replaceLastBotMessage(String text) {
    if (messages.isNotEmpty) {
      messages[messages.length - 1] = ChatMessageEntity(
        isUser: false,
        text: text,
      );
    }
  }

  void replaceLastBotMessageWithMetadata(
    String text,
    Map<String, dynamic> metadata,
  ) {
    if (messages.isNotEmpty) {
      messages[messages.length - 1] = ChatMessageEntity(
        isUser: false,
        text: text,
        metadata: metadata,
      );
    }
  }

  void clear() => messages.clear();

  void onCategoryTap() {
    Get.toNamed(RoutePath.categoryManagement);
  }

  void onTransactionTap(Map<String, dynamic> metadata) {
    if (metadata.isEmpty) return;
    final context = Get.context;
    if (context == null) return;

    final userId = appController.userId.value;
    if (userId == null) return;

    final transaction = TransactionEntity.fromMap(metadata);
    TransactionDetail.show(context, item: transaction, userId: userId);
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _speech.stop();
    super.onClose();
  }
}
