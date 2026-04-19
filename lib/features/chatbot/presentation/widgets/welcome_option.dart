import 'package:flutter/material.dart';

class WelcomeOptions extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final void Function(String template) onTapFill;
  final Future<void> Function(String template) onTapSend;

  const WelcomeOptions({
    super.key,
    required this.options,
    required this.onTapFill,
    required this.onTapSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chào mừng bạn đến với trợ lý AI!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tôi có thể giúp bạn ghi chép chi tiêu bằng giọng nói/tin nhắn hoặc phân tích xu hướng chi tiêu để đưa ra lời khuyên tài chính.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Gợi ý nhanh:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...options.map(
              (o) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          o['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          o['desc'] ?? '',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blueAccent,
                                  side: const BorderSide(color: Colors.blueAccent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => onTapFill(o['template'] ?? ''),
                                child: const Text('Nhập mẫu'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => onTapSend(o['template'] ?? ''),
                                child: const Text('Gửi luôn'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


