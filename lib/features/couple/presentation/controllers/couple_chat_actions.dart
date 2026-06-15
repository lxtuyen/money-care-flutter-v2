part of 'couple_controller.dart';

extension CoupleChatActions on CoupleController {
  SocketService get _socketService => Get.put(SocketService());

  void initSocketConnection() {
    if (couple.value == null) return;
    _socketService.connectToCoupleChat(
      coupleId: couple.value!.id,
      onMessageReceived: (data) {
        final newMsg = CoupleMessageModel.fromJson(data);
        if (!chatMessages.any((msg) => msg.id == newMsg.id)) {
          chatMessages.add(newMsg);
          _scrollToBottom();
        }
      },
      onMessageUpdated: (data) {
        final updatedMsg = CoupleMessageModel.fromJson(data);
        final idx = chatMessages.indexWhere((msg) => msg.id == updatedMsg.id);
        if (idx != -1) {
          chatMessages[idx] = updatedMsg;
          chatMessages.refresh();
        }
      },
      onMessageDeleted: (messageId) {
        chatMessages.removeWhere((msg) => msg.id == messageId);
        chatMessages.refresh();
      },
      onStreakUpdated: (data) {
        debugPrint('Streak updated from socket: $data');
        final streak = data['currentStreak'] as int? ?? 0;
        final lastActivity = data['lastActivityDate'] as String?;
        if (couple.value != null) {
          couple.value = couple.value!.copyWith(
            currentStreak: streak,
            lastActivityDate: lastActivity,
          );
          couple.refresh();
        }
      },
    );
  }

  Future<void> fetchChatHistory() async {
    if (couple.value == null) return;
    isChatLoading.value = true;
    final result = await getCoupleChatHistoryUseCase(couple.value!.id);
    result.fold(
      (failure) => debugPrint('Error fetching chat history: ${failure.message}'),
      (history) {
        chatMessages.assignAll(history);
        _scrollToBottom();
      },
    );
    isChatLoading.value = false;
  }

  void sendChatMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    _socketService.sendMessage(text);
    messageInputController.clear();
  }

  void sendSavingGoalReminder({
    required int goalId,
    required String goalName,
    required double target,
    required double savedAmount,
    int? walletId,
    double? remindAmount,
  }) {
    final amountText = remindAmount != null && remindAmount > 0
        ? ' gợi ý đóng góp ${AppHelperFunction.formatAmount(remindAmount)}'
        : '';
    final content = 'Nhắc nhở: Hãy đóng góp vào Quỹ tiết kiệm "$goalName"$amountText nhé! 💰';

    _socketService.sendMessage(
      content,
      metadata: {
        '__type': 'saving_goal_reminder',
        'goalId': goalId,
        'goalName': goalName,
        'target': target,
        'savedAmount': savedAmount,
        'walletId': walletId,
        'remindAmount': remindAmount,
      },
    );

    selectedTabIndex.value = 3; // Switch to Trò chuyện tab
  }

  void sendSettlementReminder({
    required double amount,
    required String debtorName,
    required String creditorName,
    required int debtorId,
    required int creditorId,
  }) {
    final content = 'Nhắc nhở: Hãy quyết toán khoản dư nợ chung trị giá ${AppHelperFunction.formatAmount(amount)} nhé! 🤝';

    _socketService.sendMessage(
      content,
      metadata: {
        '__type': 'settlement_reminder',
        'amount': amount,
        'debtorName': debtorName,
        'creditorName': creditorName,
        'debtorId': debtorId,
        'creditorId': creditorId,
      },
    );

    selectedTabIndex.value = 3; // Switch to Trò chuyện tab
  }

  void sendSpendingAlertReminder({
    required int alertId,
    required String title,
    required String message,
    required double amount,
  }) {
    final content = 'Cảnh báo chi tiêu: $title\n$message ⚠️';

    _socketService.sendMessage(
      content,
      metadata: {
        '__type': 'spending_alert_reminder',
        'alertId': alertId,
        'title': title,
        'message': message,
        'amount': amount,
      },
    );

    selectedTabIndex.value = 3; // Switch to Trò chuyện tab
  }

  void editMessage(int messageId, String newContent) {
    _socketService.updateMessage(messageId, newContent);
  }

  void deleteMessage(int messageId) {
    _socketService.deleteMessage(messageId);
  }

  void disconnectSocket() {
    if (Get.isRegistered<SocketService>()) {
      _socketService.disconnect();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
