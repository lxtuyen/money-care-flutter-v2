import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/voice_chat/presentation/controllers/voice_chat_controller.dart';

class VoiceChatPanel extends StatelessWidget {
  final VoiceChatController controller;
  final int userId;

  const VoiceChatPanel({
    super.key,
    required this.controller,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final isActive = controller.isActive;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _VoiceStatusDot(state: state),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _statusText(state),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: isActive ? 'Dừng voice AI' : 'Nói chuyện voice AI',
                  onPressed: userId <= 0
                      ? null
                      : () => controller.toggle(userId),
                  icon: Icon(isActive ? Icons.stop_rounded : Icons.graphic_eq),
                  color: isActive ? Colors.redAccent : Colors.blueAccent,
                  style: IconButton.styleFrom(
                    backgroundColor: isActive
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.blue.withValues(alpha: 0.06),
                  ),
                ),
              ],
            ),
            if (controller.errorMessage.value != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.errorMessage.value!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            if (controller.transcripts.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 92),
                margin: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                  reverse: true,
                  itemCount: controller.transcripts.length,
                  itemBuilder: (context, index) {
                    final item = controller
                        .transcripts[controller.transcripts.length - 1 - index];
                    return Text(
                      '${item.isUser ? 'Bạn' : 'AI'}: ${item.text}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: item.isUser ? Colors.black87 : Colors.blueGrey,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  String _statusText(VoiceChatState state) {
    switch (state) {
      case VoiceChatState.idle:
        return 'Voice AI sẵn sàng';
      case VoiceChatState.connecting:
        return 'Đang kết nối voice AI...';
      case VoiceChatState.listening:
        return 'Đang nghe bạn nói';
      case VoiceChatState.thinking:
        return 'AI đang xử lý';
      case VoiceChatState.speaking:
        return 'AI đang trả lời';
      case VoiceChatState.error:
        return 'Voice AI gặp lỗi';
    }
  }
}

class _VoiceStatusDot extends StatelessWidget {
  final VoiceChatState state;

  const _VoiceStatusDot({required this.state});

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      VoiceChatState.idle => Colors.grey,
      VoiceChatState.connecting => Colors.orangeAccent,
      VoiceChatState.listening => Colors.green,
      VoiceChatState.thinking => Colors.amber,
      VoiceChatState.speaking => Colors.blueAccent,
      VoiceChatState.error => Colors.redAccent,
    };

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
