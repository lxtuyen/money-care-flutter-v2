import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/chatbot/presentation/widgets/bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/welcome_option.dart';
import 'package:money_care/features/chatbot/presentation/widgets/analysis_bubble.dart';

import 'package:money_care/features/chatbot/presentation/widgets/transaction_saved_bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/transaction_list_bubble.dart';

import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_created_bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_proposal_bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/saving_goal_initial_fund_ask_bubble.dart';
import 'package:money_care/features/chatbot/presentation/widgets/scenario_simulation_bubble.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
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

      return ListView.separated(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: messages.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final m = messages[index];
          if (!m.isUser && m.metadata != null) {
            if (m.metadata!['__type'] == 'transaction_saved') {
              return TransactionSavedBubble(metadata: m.metadata!);
            }
            if (m.metadata!['__type'] == 'transaction_list') {
              return TransactionListBubble(metadata: m.metadata!);
            }

            if (m.metadata!['__type'] == 'saving_goal_created') {
              return SavingGoalCreatedBubble(metadata: m.metadata!);
            }
            if (m.metadata!['__type'] == 'saving_goal_initial_fund_ask') {
              return SavingGoalInitialFundAskBubble(metadata: m.metadata!);
            }
            if (m.metadata!['__type'] == 'saving_goal_proposal') {
              return SavingGoalProposalBubble(metadata: m.metadata!);
            }
            if (m.metadata!['__type'] == 'scenario_simulation') {
              return ScenarioSimulationBubble(metadata: m.metadata!);
            }

            return AnalysisBubble(metadata: m.metadata!);
          }
          return Bubble(isUser: m.isUser, text: m.text, imagePath: m.imagePath);
        },
      );
    });
  }

  Widget _buildInputArea() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSuggestionChips(),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'chatbot.hintText'.tr,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => controller.send(userId ?? 0),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => controller.pickAndScanReceipt(userId ?? 0),
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.blueAccent,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.withValues(alpha: 0.05),
                  ),
                ),
                const SizedBox(width: 4),
                _buildMicButton(),
                const SizedBox(width: 4),
                _buildSendButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return Container(
      height: 52,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.options.length,
        itemBuilder: (context, index) {
          final opt = controller.options[index];
          final title = opt.title;
          final template = opt.template;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => controller.fillTemplate(template),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSecondary),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.text1.withValues(alpha: 0.01),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMicButton() {
    return Obx(
      () => IconButton(
        onPressed: controller.toggleListening,
        icon: Icon(
          controller.isListening.value ? Icons.mic : Icons.mic_none_rounded,
          color: controller.isListening.value
              ? Colors.redAccent
              : Colors.blueAccent,
        ),
        style: IconButton.styleFrom(
          backgroundColor: controller.isListening.value
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.blue.withValues(alpha: 0.05),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Obx(
      () => IconButton(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.send(userId ?? 0),
        icon: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blueAccent,
                ),
              )
            : const Icon(Icons.send_rounded, color: Colors.blueAccent),
      ),
    );
  }
}
