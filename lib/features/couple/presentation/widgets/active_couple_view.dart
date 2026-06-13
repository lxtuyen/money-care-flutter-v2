import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/app/widgets/button/app_outline_button.dart';

class ActiveCoupleView extends StatelessWidget {
  final CoupleEntity couple;
  final CoupleController controller;
  final int currentUserId;

  const ActiveCoupleView({
    super.key,
    required this.couple,
    required this.controller,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    final partner = couple.partner(currentUserId);
    final me = couple.me(currentUserId);

    if (partner == null || me == null) {
      return const Center(child: Text('Đang tải thông tin thành viên...'));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          
          // Partner Card
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[150] ?? const Color(0xFFEEEEEE)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: primaryColor.withValues(alpha: 0.1),
                        backgroundImage: partner.avatar != null && partner.avatar!.isNotEmpty
                            ? NetworkImage(partner.avatar!)
                            : null,
                        child: partner.avatar == null || partner.avatar!.isEmpty
                            ? Text(
                                partner.initials,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    partner.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    partner.email,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Đã kết nối',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Privacy Settings Title
          Text(
            'THIẾT LẬP QUYỀN RIÊNG TƯ CỦA BẠN',
            style: theme.textTheme.bodySmall?.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 12),

          // Privacy Card
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SwitchListTile(
                    value: me.sharePersonalTransactions,
                    onChanged: (val) => controller.toggleShareTransactions(val),
                    title: const Text(
                      'Chia sẻ giao dịch cá nhân',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Cho phép đối phương xem lịch sử giao dịch cá nhân của bạn.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    activeColor: primaryColor,
                  ),
                  Divider(color: Colors.grey[100]),
                  SwitchListTile(
                    value: me.allowAiShare,
                    onChanged: (val) => controller.toggleAllowAiShare(val),
                    title: const Text(
                      'Cấp quyền cho AI',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Cho phép chatbot sử dụng dữ liệu giao dịch của bạn để trả lời các câu hỏi từ partner.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    activeColor: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Disconnect Button
          AppOutlineButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Ngắt kết nối cặp đôi?'),
                  content: const Text(
                    'Bạn có chắc chắn muốn ngắt kết nối với đối phương không? Mọi lịch sử và không gian chung sẽ tạm thời bị ngắt liên kết.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        controller.leaveCoupleSpace();
                      },
                      child: const Text(
                        'Xác nhận rời',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icons.exit_to_app_rounded,
            label: 'Ngắt kết nối',
            textColor: Colors.red,
            borderColor: Colors.red,
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(vertical: 16),
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
