import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/couple/domain/entities/couple_message_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class CoupleChatView extends StatelessWidget {
  final CoupleController controller;

  const CoupleChatView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id ?? 0;

    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.isChatLoading.value && controller.chatMessages.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.chatMessages.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.forum_rounded,
                          size: 64,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có tin nhắn nào',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bắt đầu trò chuyện và chia sẻ tài chính cùng đối phương nhé! 💬',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              controller: controller.chatScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: controller.chatMessages.length,
              itemBuilder: (context, index) {
                final message = controller.chatMessages[index];
                final isMe = message.senderId == currentUserId;

                // Check if we should show date separator
                bool showDateSeparator = false;
                if (index == 0) {
                  showDateSeparator = true;
                } else {
                  final prevMessage = controller.chatMessages[index - 1];
                  if (message.createdAt.day != prevMessage.createdAt.day ||
                      message.createdAt.month != prevMessage.createdAt.month ||
                      message.createdAt.year != prevMessage.createdAt.year) {
                    showDateSeparator = true;
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDateSeparator) _buildDateSeparator(context, message.createdAt),
                    _buildMessageItem(context, message, isMe, colors),
                  ],
                );
              },
            );
          }),
        ),
        _buildInputArea(context, colors),
      ],
    );
  }

  Widget _buildDateSeparator(BuildContext context, DateTime dateTime) {
    final colors = AppThemeColors.of(context);
    final now = DateTime.now();
    String dateText = '';

    if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
      dateText = 'Hôm nay';
    } else if (dateTime.day == now.subtract(const Duration(days: 1)).day &&
        dateTime.month == now.subtract(const Duration(days: 1)).month &&
        dateTime.year == now.subtract(const Duration(days: 1)).year) {
      dateText = 'Hôm qua';
    } else {
      dateText = DateFormat('dd/MM/yyyy').format(dateTime);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: colors.borderSecondary, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
          ),
          Expanded(child: Divider(color: colors.borderSecondary, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    CoupleMessageEntity message,
    bool isMe,
    AppThemeColors colors,
  ) {
    final messageBgColor = isMe
        ? Theme.of(context).primaryColor
        : colors.cardBackground;

    final textColor = isMe ? Colors.white : colors.textPrimary;
    final timeColor = isMe ? Colors.white70 : colors.textMuted;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _buildAvatar(message.senderAvatar, message.senderName),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && message.senderName != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(
                      message.senderName!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
                if (message.metadata != null && message.metadata!['__type'] == 'saving_goal_reminder')
                  _buildSavingGoalReminderCard(context, message, isMe, colors)
                else if (message.metadata != null && message.metadata!['__type'] == 'settlement_reminder')
                  _buildSettlementReminderCard(context, message, isMe, colors)
                else if (message.metadata != null &&
                    (message.metadata!['__type'] == 'settlement_completed' ||
                     message.metadata!['__type'] == 'single_settlement_completed'))
                  _buildSettlementCompletedCard(context, message, colors)
                else if (message.metadata != null &&
                    (message.metadata!['__type'] == 'saving_contribution_completed' ||
                     message.metadata!['__type'] == 'saving_goal_completed'))
                  _buildSavingContributionCompletedCard(context, message, colors)
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: messageBgColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                  child: Text(
                    DateFormat('HH:mm').format(message.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: timeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 24), // Offset space
        ],
      ),
    );
  }

  Widget _buildSavingGoalReminderCard(
    BuildContext context,
    CoupleMessageEntity message,
    bool isMe,
    AppThemeColors colors,
  ) {
    final meta = message.metadata!;
    final goalId = meta['goalId'] as int?;
    
    final actualGoal = goalId != null
        ? controller.savingGoals.firstWhereOrNull((g) => g.id == goalId)
        : null;

    final goalName = actualGoal?.name ?? meta['goalName'] as String? ?? 'Quỹ tiết kiệm';
    final target = actualGoal?.target ?? (meta['target'] as num?)?.toDouble() ?? 0.0;
    final savedAmount = actualGoal?.savedAmount ?? (meta['savedAmount'] as num?)?.toDouble() ?? 0.0;
    final remindAmount = (meta['remindAmount'] as num?)?.toDouble();
    final walletId = actualGoal?.walletId ?? meta['walletId'] as int?;

    final progress = target > 0 ? (savedAmount / target).clamp(0.0, 1.0) : 0.0;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 16),
        ),
        border: Border.all(color: colors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.savings_rounded,
                color: primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'NHẮC ĐÓNG QUỸ TIẾT KIỆM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goalName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tích lũy: ${AppHelperFunction.formatAmount(savedAmount)}',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              Text(
                'Mục tiêu: ${AppHelperFunction.formatAmount(target)}',
                style: TextStyle(fontSize: 11, color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colors.surfaceBackground,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Đạt ${(progress * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: colors.textMuted,
            ),
          ),
          if (remindAmount != null && remindAmount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 12, color: Colors.amber[800]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Gợi ý đóng góp: ${AppHelperFunction.formatAmount(remindAmount)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (walletId != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => Get.toNamed(
                  RoutePath.walletTransfer,
                  arguments: {
                    'toWalletId': walletId,
                    'lockToWallet': true,
                  },
                ),
                child: const Text(
                  'Đóng góp ngay',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettlementReminderCard(
    BuildContext context,
    CoupleMessageEntity message,
    bool isMe,
    AppThemeColors colors,
  ) {
    final meta = message.metadata!;
    final amount = (meta['amount'] as num?)?.toDouble() ?? 0.0;
    final debtorName = meta['debtorName'] as String? ?? 'Thành viên';
    final creditorName = meta['creditorName'] as String? ?? 'Thành viên';
    final debtorId = meta['debtorId'] as int? ?? 0;

    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id ?? 0;
    final amIDebtor = currentUserId == debtorId;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 16),
        ),
        border: Border.all(
          color: amIDebtor ? Colors.red.withValues(alpha: 0.3) : colors.borderSecondary,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.handshake_rounded,
                color: amIDebtor ? Colors.red : Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'NHẮC QUYẾT TOÁN SỐ DƯ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: amIDebtor ? Colors.red[700] : colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amIDebtor
                ? 'Bạn đang có khoản dư nợ cần thanh toán cho $creditorName'
                : '$debtorName đang có khoản dư nợ cần thanh toán cho bạn',
            style: TextStyle(
              fontSize: 13,
              color: colors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppHelperFunction.formatAmount(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: amIDebtor ? Colors.red[700] : Colors.green[700],
            ),
          ),
          if (amIDebtor) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  controller.selectedTabIndex.value = 1;
                  controller.selectedSubTabIndex.value = 1;
                },
                child: const Text(
                  'Quyết toán ngay',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettlementCompletedCard(
    BuildContext context,
    CoupleMessageEntity message,
    AppThemeColors colors,
  ) {
    final meta = message.metadata!;
    final type = meta['__type'] as String;
    final isSingle = type == 'single_settlement_completed';

    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isSingle ? 'QUYẾT TOÁN KHOẢN CHI' : 'QUYẾT TOÁN TẤT CẢ',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 13,
              color: colors.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingContributionCompletedCard(
    BuildContext context,
    CoupleMessageEntity message,
    AppThemeColors colors,
  ) {
    final meta = message.metadata!;
    final isGoalClose = meta['__type'] == 'saving_goal_completed';

    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.savings_rounded,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isGoalClose ? 'HOÀN THÀNH QUỸ TIẾT KIỆM' : 'ĐÓNG GÓP QUỸ TIẾT KIỆM',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 13,
              color: colors.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl, String? name) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }
    final initials = name != null && name.trim().isNotEmpty
        ? name.trim().substring(0, 1).toUpperCase()
        : '?';

    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.blueGrey.shade100,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, AppThemeColors colors) {
    final primaryColor = Theme.of(context).primaryColor;
    final textController = controller.messageInputController;
    final RxBool hasText = false.obs;

    textController.addListener(() {
      hasText.value = textController.text.trim().isNotEmpty;
    });

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom > 0 ? 12 : 24,
      ),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        border: Border(
          top: BorderSide(color: colors.borderSecondary),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: TextStyle(color: colors.textHint, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                filled: true,
                fillColor: colors.surfaceBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(() {
            final enabled = hasText.value;
            return AnimatedScale(
              scale: enabled ? 1.0 : 0.9,
              duration: const Duration(milliseconds: 150),
              child: InkWell(
                onTap: enabled ? () => controller.sendChatMessage() : null,
                borderRadius: BoxShape.circle.borderRadius,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: enabled ? primaryColor : colors.borderSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: enabled ? Colors.white : colors.textMuted,
                    size: 20,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

extension on BoxShape {
  BorderRadius get borderRadius => const BorderRadius.all(Radius.circular(999));
}
