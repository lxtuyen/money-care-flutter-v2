import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/features/chatbot/presentation/screens/widgets/bubble.dart';
import 'package:money_care/features/chatbot/presentation/screens/widgets/welcome_option.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final AppController appController = Get.find<AppController>();
  final ChatController chatController = Get.find<ChatController>();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechReady = false;
  bool _isListening = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    initData();
    _initSpeech();
  }

  /// Get userId from centralized AppController
  Future<void> initData() async {
    userId = await appController.getCurrentUserId();
    if (mounted) {
      setState(() {});
    }
  }

  final List<Map<String, dynamic>> _options = const [];

  void _fillTemplate(String t) {
    _controller.text = t;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  Future<void> _sendTemplate(String t) async {
    _fillTemplate(t);
    await _send();
  }

  Future<void> _initSpeech() async {
    final ok = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
      },
    );
    if (mounted) setState(() => _speechReady = ok);
  }

  Future<void> _toggleListen() async {
    if (!_speechReady) return;

    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    if (mounted) setState(() => _isListening = true);

    await _speech.listen(
      localeId: 'vi_VN',
      listenMode: stt.ListenMode.dictation,
      onResult: (result) {
        _controller.text = result.recognizedWords;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      },
    );
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || chatController.isLoading.value) return;
    if (userId == null) {
      Get.snackbar('Loi', 'Khong the xac dinh nguoi dung hien tai');
      return;
    }

    chatController.addUserMessage(text);
    chatController.addBotMessage('...');
    _controller.clear();
    _scrollToBottom();

    try {
      final reply = await chatController.send(text, userId!);
      chatController.replaceLastBotMessage(reply);
      _scrollToBottom();
    } catch (e) {
      chatController.replaceLastBotMessage('Loi goi chatbot: $e');
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/ai.gif',
                width: 34,
                height: 34,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Money Care Chatbot'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(height: 1),
            Obx(() {
              final listMessages = chatController.messages;

              return Expanded(
                child:
                    listMessages.isEmpty
                        ? WelcomeOptions(
                          options: _options,
                          onTapFill: _fillTemplate,
                          onTapSend: _sendTemplate,
                        )
                        : ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.all(12),
                          itemCount: listMessages.length,
                          itemBuilder: (context, i) {
                            final m = listMessages[i];
                            return Bubble(isUser: m.isUser, text: m.text);
                          },
                        ),
              );
            }),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'Nhap tin nhan...',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _toggleListen,
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      color: _speechReady ? Colors.blueAccent : Colors.grey,
                      tooltip:
                          _speechReady
                              ? (_isListening ? 'Dung' : 'Noi de nhap')
                              : 'Chua san sang',
                    ),
                    IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.send),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
