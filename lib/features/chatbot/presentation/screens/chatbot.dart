import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/chatbot/presentation/widgets/bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/welcome_option.dart';
import 'package:money_care/features/chatbot/presentation/widgets/analysis_bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/receipt_items_bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/transaction_saved_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatController controller = Get.find<ChatController>();
  final AppController appController = Get.find<AppController>();
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    userId = await appController.getCurrentUserId();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(height: 1),
            Expanded(child: _buildMessageList()),
            const Divider(height: 1),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: 34,
              height: 34,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Money Care AI',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      final messages = controller.messages;
      if (messages.isEmpty) {
        return WelcomeOptions(
          options: controller.options,
          onTapFill: controller.fillTemplate,
          onTapSend: (t) => controller.sendTemplate(t, userId ?? 0),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final m = messages[index];
          if (!m.isUser && m.metadata != null) {
            if (m.metadata!['__type'] == 'transaction_saved') {
              return TransactionSavedBubble(metadata: m.metadata!);
            }
            if (m.metadata!.containsKey('items')) {
              return ReceiptItemsBubble(metadata: m.metadata!);
            }
            return AnalysisBubble(metadata: m.metadata!);
          }
          return Bubble(isUser: m.isUser, text: m.text);
        },
      );
    });
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Hỏi AI bất cứ điều gì...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.image_outlined, color: Colors.blueAccent),
                  onPressed: controller.pickAndSendImage,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => controller.send(userId ?? 0),
            ),
          ),
          const SizedBox(width: 8),
          _buildMicButton(),
          const SizedBox(width: 4),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return Obx(() => IconButton(
      onPressed: controller.toggleListening,
      icon: Icon(
        controller.isListening.value ? Icons.mic : Icons.mic_none_rounded,
        color: controller.isListening.value ? Colors.redAccent : Colors.blueAccent,
      ),
      style: IconButton.styleFrom(
        backgroundColor: controller.isListening.value 
          ? Colors.red.withValues(alpha: 0.1) 
          : Colors.blue.withValues(alpha: 0.05),
      ),
    ));
  }

  Widget _buildSendButton() {
    return Obx(() => IconButton(
      onPressed: controller.isLoading.value ? null : () => controller.send(userId ?? 0),
      icon: controller.isLoading.value
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
            )
          : const Icon(Icons.send_rounded, color: Colors.blueAccent),
    ));
  }
}


