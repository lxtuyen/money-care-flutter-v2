import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  final bool isUser;
  final String text;

  const Bubble({required this.isUser, required this.text});

  @override
  Widget build(BuildContext context) {
    final bg = isUser ? Colors.blueAccent : Colors.grey.shade200;
    final fg = isUser ? Colors.white : Colors.black87;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: TextStyle(color: fg)),
        ),
      ),
    );
  }
}