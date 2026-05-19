import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final String? imagePath;

  const Bubble({
    super.key,
    required this.isUser,
    required this.text,
    this.imagePath,
  });

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
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              GestureDetector(
                onTap: () => _showFullScreenImage(context, imagePath!),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(text, style: TextStyle(color: fg)),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String path) {
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(child: InteractiveViewer(child: Image.file(File(path)))),
      ),
      fullscreenDialog: true,
    );
  }
}
