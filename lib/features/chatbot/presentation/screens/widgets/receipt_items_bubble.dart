import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ReceiptItemsBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const ReceiptItemsBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final String merchant = metadata['merchant_name'] ?? 'Hóa đơn';
    final List items = metadata['items'] as List? ?? [];
    final String? dateStr = metadata['date'];
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    String formattedDate = 'Hôm nay';
    if (dateStr != null) {
      try {
        final date = DateTime.parse(dateStr);
        formattedDate = DateFormat('EEE, MMM d').format(date);
      } catch (_) {}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty)
          const Text('Không tìm thấy mục nào trên hóa đơn.')
        else ...[
          ...items.map((item) =>
              _buildItemCard(item, merchant, formattedDate, currencyFormat)),
          const SizedBox(height: 8),
          _buildSaveAllButton(context, items),
        ],
      ],
    );
  }

  Widget _buildSaveAllButton(BuildContext context, List items) {
    final chatController = Get.find<ChatController>();

    return Obx(() {
      final isLoading = chatController.isLoading.value;

      return Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : () => chatController.saveReceiptItems(items),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.save_2_copy, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Lưu tất cả vào nhật ký',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildItemCard(
      dynamic item, String merchant, String date, NumberFormat format) {
    final String itemName = item['name'] ?? 'Sản phẩm';
    final double amount = (item['amount'] as num?)?.toDouble() ?? 0;
    final String category = item['category'] ?? 'Khác';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đã ghi nhận: Chi phí',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Iconsax.shop_copy, color: Colors.orangeAccent, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      itemName,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                format.format(amount),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
