import 'package:flutter/material.dart';

class WelcomeOptions extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final void Function(String template) onTapFill;
  final Future<void> Function(String template) onTapSend;

  const WelcomeOptions({
    required this.options,
    required this.onTapFill,
    required this.onTapSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xin chÃ o \nBáº¡n cÃ³ thá»ƒ gÃµ hoáº·c nÃ³i theo cÃº phÃ¡p bÃªn dÆ°á»›i:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  options.map((o) {
                    return ActionChip(
                      label: Text('123'),
                      labelStyle: const TextStyle(color: Colors.blueAccent),
                      onPressed: () => onTapFill(''),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 14),
            const Text(
              'VÃ­ dá»¥ lá»‡nh',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            ...options.map(
              (o) => Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.lightBlue),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'sss',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ssss',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blueAccent,
                                side: const BorderSide(
                                  color: Colors.blueAccent,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => onTapFill('ádđ'),
                              child: const Text('DÃ¡n máº«u'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'Máº¹o voice : báº¥m mic vÃ  nÃ³i giá»‘ng vÃ­ dá»¥, vÃ­ dá»¥: "thÃªm chi tiÃªu 50 nghÃ¬n Äƒn sÃ¡ng hÃ´m nay".',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
