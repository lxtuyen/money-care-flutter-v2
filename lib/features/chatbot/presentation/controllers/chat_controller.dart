import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';

import 'package:money_care/features/chatbot/domain/entities/entities.dart';
import 'package:money_care/features/chatbot/data/models/models.dart';

import 'package:money_care/features/chatbot/domain/usecases/chat_usecases.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/services/ocr_service.dart';
import 'package:money_care/features/transaction/data/utils/receipt_parser.dart';
import 'package:money_care/features/transaction/data/models/transaction_filter_dto.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';

class ChatController extends GetxController {
  final SendToChatbotUseCase sendToChatbotUseCase;
  final FilterTransactionsUseCase filterTransactionsUseCase;
  final OCRService _ocrService;

  ChatController({
    required this.sendToChatbotUseCase,
    required this.filterTransactionsUseCase,
    required OCRService ocrService,
  }) : _ocrService = ocrService;

  final AppController appController = Get.find<AppController>();
  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;

  final ImagePicker _picker = ImagePicker();

  List<QuickOption> get options => [
    QuickOption(
      title: 'chatbot.savingGoalTitle'.tr,
      subtitle: 'chatbot.savingGoalDesc'.tr,
      template: 'chatbot.savingGoalTemplate'.tr,
    ),
    QuickOption(
      title: 'chatbot.quickRecordTitle'.tr,
      subtitle: 'chatbot.quickRecordDesc'.tr,
      template: 'chatbot.quickRecordTemplate'.tr,
    ),
    QuickOption(
      title: 'chatbot.analysisTitle'.tr,
      subtitle: 'chatbot.analysisDesc'.tr,
      template: 'chatbot.analysisTemplate'.tr,
    ),
    QuickOption(
      title: 'chatbot.budgetTitle'.tr,
      subtitle: 'chatbot.budgetDesc'.tr,
      template: 'chatbot.budgetTemplate'.tr,
    ),
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
    ever(transactionController.transactionChangedCount, (_) {
      _syncMessagesWithDatabase();
    });
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
      addUserMessage('', imagePath: image.path);
      addBotMessage('...');
      scrollToBottom();

      final recognizedText = await _ocrService.processImage(image.path);

      if (!_ocrService.checkIfReceipt(recognizedText) ||
          recognizedText.text.length < 20) {
        replaceLastBotMessage('chatbot.imageTooBlurry'.tr);
        return;
      }

      final lines = ReceiptParser.extractLines(recognizedText);

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
      final result = await sendToChatbotUseCase(dto);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          replaceLastBotMessage(
            'chatbot.connectionError'.tr.replaceAll('@error', failure.message),
          );
        },
        (reply) => _handleBotReply(reply, userId),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      replaceLastBotMessage(
        'chatbot.connectionError'.tr.replaceAll('@error', e.toString()),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendCustomMessage(
    String displayMsg,
    String payloadMsg,
    int userId,
  ) async {
    if (isLoading.value) return;

    try {
      addUserMessage(displayMsg);
      addBotMessage('...');
      scrollToBottom();

      isLoading.value = true;
      errorMessage.value = null;

      final dto = ChatDto(message: payloadMsg, userId: userId);
      final result = await sendToChatbotUseCase(dto);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          replaceLastBotMessage('Có lỗi xảy ra: ${failure.message}');
        },
        (reply) => _handleBotReply(reply, userId),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      replaceLastBotMessage('Có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
      scrollToBottom();
    }
  }

  void _handleBotReply(String reply, int userId) {
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
        transactionController.refreshAllData(userId);

        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().refreshWallets();
        }

        if (savingGoalController.goalId.value > 0) {
          savingGoalController.loadGoalById();
        }

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
      try {
        transactionController.refreshAllData(userId);

        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().refreshWallets();
        }

        if (savingGoalController.goalId.value > 0) {
          savingGoalController.loadGoalById();
        }

        if (Get.isRegistered<StatisticsController>()) {
          Get.find<StatisticsController>().refreshStatisticsData(userId);
        }

        if (Get.isRegistered<GamificationController>()) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.find<GamificationController>().recordDailyTransaction();
          });
        }
      } catch (_) {}
    } else if (reply.startsWith('__SAVING_GOAL_INITIAL_FUND_ASK__')) {
      final jsonStr = reply.replaceFirst(
        '__SAVING_GOAL_INITIAL_FUND_ASK__',
        '',
      );
      try {
        final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
        data['__type'] = 'saving_goal_initial_fund_ask';
        replaceLastBotMessageWithMetadata('', data);
      } catch (e) {
        replaceLastBotMessage(
          'Tôi đã tìm thấy một số ví có sẵn của bạn để tích lũy ban đầu!',
        );
      }
    } else if (reply.startsWith('__SAVING_GOAL_PROPOSAL__')) {
      final jsonStr = reply.replaceFirst('__SAVING_GOAL_PROPOSAL__', '');
      try {
        final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
        data['__type'] = 'saving_goal_proposal';
        replaceLastBotMessageWithMetadata('', data);
      } catch (e) {
        replaceLastBotMessage('Tôi đã ghi nhận đề xuất tích lũy của bạn!');
      }
    } else if (reply.startsWith('__SAVING_GOAL_CREATED__')) {
      final jsonStr = reply.replaceFirst('__SAVING_GOAL_CREATED__', '');
      try {
        final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
        data['__type'] = 'saving_goal_created';
        _finalizeSavingGoalProposals(data);
        replaceLastBotMessageWithMetadata('', data);
      } catch (e) {
        replaceLastBotMessage('Đã tạo mục tiêu tiết kiệm thành công!');
      }
      try {
        final userId = appController.userId.value;
        if (userId != null) {
          savingGoalController.loadGoals(userId);
          if (Get.isRegistered<WalletController>()) {
            Get.find<WalletController>().refreshWallets();
          }
          if (Get.isRegistered<StatisticsController>()) {
            Get.find<StatisticsController>().refreshStatisticsData(userId);
          }
          final activeGoalId = savingGoalController.goalId.value;
          if (activeGoalId > 0) {
            savingGoalController.loadGoalReport(activeGoalId);
            savingGoalController.loadGoalById();
          }
        }
      } catch (_) {}
    } else if (reply.startsWith('__SCENARIO_SIMULATION__')) {
      final jsonStr = reply.replaceFirst('__SCENARIO_SIMULATION__', '');
      try {
        final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
        data['__type'] = 'scenario_simulation';
        replaceLastBotMessageWithMetadata('', data);
      } catch (e) {
        replaceLastBotMessage(reply.replaceFirst('__SCENARIO_SIMULATION__', ''));
      }
    } else if (reply.startsWith('__BUDGET_RECOMMENDATION__')) {
      final jsonStr = reply.replaceFirst('__BUDGET_RECOMMENDATION__', '');
      try {
        final data = Map<String, dynamic>.from(jsonDecode(jsonStr));
        data['__type'] = 'budget_recommendation';
        replaceLastBotMessageWithMetadata('', data);
      } catch (e) {
        replaceLastBotMessage(reply.replaceFirst('__BUDGET_RECOMMENDATION__', ''));
      }
    } else {
      replaceLastBotMessage(reply);
    }
    scrollToBottom();
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
    messages.add(
      ChatMessageEntity(isUser: true, text: text, imagePath: imagePath),
    );
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

  void _finalizeSavingGoalProposals(Map<String, dynamic> createdGoal) {
    final createdName = createdGoal['name']?.toString();
    final createdTarget = (createdGoal['target'] as num?)?.toDouble();

    for (var i = 0; i < messages.length; i++) {
      final metadata = messages[i].metadata;
      if (metadata == null) continue;

      final type = metadata['__type'];
      if (type != 'saving_goal_proposal' &&
          type != 'saving_goal_initial_fund_ask') {
        continue;
      }

      final proposalName = metadata['name']?.toString();
      final proposalTarget = (metadata['target'] as num?)?.toDouble();
      final isSameGoal =
          (createdName == null || proposalName == createdName) &&
          (createdTarget == null || proposalTarget == createdTarget);

      if (!isSameGoal) continue;

      final updatedMetadata = Map<String, dynamic>.from(metadata);
      updatedMetadata['isFinalized'] = true;
      updatedMetadata['finalizedLabel'] = 'Mục tiêu này đã được tạo';

      messages[i] = ChatMessageEntity(
        isUser: messages[i].isUser,
        text: messages[i].text,
        imagePath: messages[i].imagePath,
        metadata: updatedMetadata,
      );
    }
  }

  void _syncMessagesWithDatabase() async {
    final userId = appController.userId.value;
    if (userId == null) return;

    try {
      final result = await filterTransactionsUseCase(
        userId,
        const TransactionFilterDto(),
      );

      final allTrans = [...result.incomeTransactions, ...result.expenseTransactions];

      bool updatedAny = false;
      for (var i = 0; i < messages.length; i++) {
        final msg = messages[i];
        final metadata = msg.metadata;
        if (metadata == null) continue;

        final type = metadata['__type'];
        if (type == 'transaction_saved') {
          final transId = metadata['id'];
          if (transId != null) {
            TransactionEntity? dbTrans;
            for (final t in allTrans) {
              if (t.id == transId) {
                dbTrans = t;
                break;
              }
            }

            if (dbTrans != null) {
              final newMetadata = Map<String, dynamic>.from(metadata);
              newMetadata['amount'] = dbTrans.amount;
              newMetadata['note'] = dbTrans.note;
              newMetadata['date'] = dbTrans.transactionDate?.toIso8601String();
              newMetadata['walletId'] = dbTrans.walletId;
              newMetadata['walletName'] = dbTrans.walletName;
              if (dbTrans.category != null) {
                newMetadata['category'] = {
                  'id': dbTrans.category!.id,
                  'name': dbTrans.category!.name,
                  'icon': dbTrans.category!.icon,
                };
              }
              if (dbTrans.subCategory != null) {
                newMetadata['subCategory'] = {
                  'id': dbTrans.subCategory!.id,
                  'name': dbTrans.subCategory!.name,
                  'icon': dbTrans.subCategory!.icon,
                };
              } else {
                newMetadata['subCategory'] = null;
              }

              messages[i] = ChatMessageEntity(
                isUser: msg.isUser,
                text: msg.text,
                imagePath: msg.imagePath,
                metadata: newMetadata,
              );
              updatedAny = true;
            }
          }
        } else if (type == 'transaction_list') {
          final list = metadata['transactions'] as List? ?? [];
          final newList = [];
          bool listUpdated = false;

          for (var item in list) {
            if (item is Map) {
              final transId = item['id'];
              if (transId != null) {
                TransactionEntity? dbTrans;
                for (final t in allTrans) {
                  if (t.id == transId) {
                    dbTrans = t;
                    break;
                  }
                }

                if (dbTrans != null) {
                  final newItem = Map<String, dynamic>.from(item);
                  newItem['amount'] = dbTrans.amount;
                  newItem['note'] = dbTrans.note;
                  newItem['date'] = dbTrans.transactionDate?.toIso8601String();
                  newItem['walletId'] = dbTrans.walletId;
                  newItem['walletName'] = dbTrans.walletName;
                  if (dbTrans.category != null) {
                    newItem['category'] = {
                      'id': dbTrans.category!.id,
                      'name': dbTrans.category!.name,
                      'icon': dbTrans.category!.icon,
                    };
                  }
                  if (dbTrans.subCategory != null) {
                    newItem['subCategory'] = {
                      'id': dbTrans.subCategory!.id,
                      'name': dbTrans.subCategory!.name,
                      'icon': dbTrans.subCategory!.icon,
                    };
                  } else {
                    newItem['subCategory'] = null;
                  }
                  newList.add(newItem);
                  listUpdated = true;
                } else {
                  newList.add(item);
                }
              } else {
                newList.add(item);
              }
            } else {
              newList.add(item);
            }
          }

          if (listUpdated) {
            final newMetadata = Map<String, dynamic>.from(metadata);
            newMetadata['transactions'] = newList;
            newMetadata['total'] = newList.length;

            messages[i] = ChatMessageEntity(
              isUser: msg.isUser,
              text: msg.text,
              imagePath: msg.imagePath,
              metadata: newMetadata,
            );
            updatedAny = true;
          }
        }
      }
      if (updatedAny) {
        messages.refresh();
      }
    } catch (e) {
      debugPrint('Lỗi đồng bộ tin nhắn chatbot: $e');
    }
  }

  void clear() => messages.clear();

  void onCategoryTap() {
    Get.toNamed(RoutePath.categoryManagement);
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _speech.stop();
    super.onClose();
  }
}
