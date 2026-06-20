import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class PhotoTransactionGalleryScreen extends StatelessWidget {
  final List<TransactionEntity> photoTransactions;
  final ValueChanged<int> onSelect;

  const PhotoTransactionGalleryScreen({
    super.key,
    required this.photoTransactions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Tất cả ảnh giao dịch',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: photoTransactions.isEmpty
          ? const Center(
              child: Text(
                'Không có ảnh giao dịch nào.',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              cacheExtent: 500,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: photoTransactions.length,
              itemBuilder: (context, index) {
                final tx = photoTransactions[index];
                final pictureUrl = tx.pictureUrl;

                // Fade-in frameBuilder for smooth image appearance
                Widget Function(BuildContext, Widget, int?, bool)? frameBuilder;
                frameBuilder = (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: child,
                  );
                };

                Widget imageWidget;
                if (pictureUrl == null || pictureUrl.isEmpty) {
                  imageWidget = Container(
                    color: const Color(0xFF1E1E1E),
                    child: const Icon(Icons.photo_outlined,
                        color: Colors.white30, size: 36),
                  );
                } else if (pictureUrl.startsWith('http')) {
                  imageWidget = Image.network(
                    pictureUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 300,
                    frameBuilder: frameBuilder,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF1E1E1E),
                      child: const Icon(Icons.broken_image,
                          color: Colors.white30, size: 36),
                    ),
                  );
                } else {
                  imageWidget = Image.file(
                    File(pictureUrl),
                    fit: BoxFit.cover,
                    cacheWidth: 300,
                    frameBuilder: frameBuilder,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF1E1E1E),
                      child: const Icon(Icons.broken_image,
                          color: Colors.white30, size: 36),
                    ),
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {
                      onSelect(index);
                      Get.back();
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        imageWidget,
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12, width: 0.5),
                            ),
                            child: Text(
                              AppHelperFunction.formatAmount(
                                  tx.amount.toDouble()),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
