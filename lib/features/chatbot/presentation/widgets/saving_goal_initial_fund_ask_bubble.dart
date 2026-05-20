import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';

class SavingGoalInitialFundAskBubble extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const SavingGoalInitialFundAskBubble({super.key, required this.metadata});

  @override
  State<SavingGoalInitialFundAskBubble> createState() =>
      _SavingGoalInitialFundAskBubbleState();
}

class _ChatbotWallet {
  final int id;
  final String name;
  final double balance;
  final String type;

  _ChatbotWallet({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
  });

  factory _ChatbotWallet.fromMap(Map<String, dynamic> map) {
    return _ChatbotWallet(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name']?.toString() ?? '',
      balance: (map['balance'] as num?)?.toDouble() ?? 0,
      type: map['type']?.toString() ?? 'general',
    );
  }
}

class _SavingGoalInitialFundAskBubbleState
    extends State<SavingGoalInitialFundAskBubble> {
  late String name;
  late double target;
  late List<_ChatbotWallet> wallets;
  late double totalBalance;
  late int selectedWalletId;
  late int requestedMonths;

  int activeWalletIndex = 0;
  double customAmount = 0;
  String selectedPercent = '0%'; // '0%', '10%', '20%', '50%', 'custom'
  final TextEditingController amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    name = widget.metadata['name'] ?? 'Mục tiêu tiết kiệm';
    target = (widget.metadata['target'] as num?)?.toDouble() ?? 0;
    totalBalance = (widget.metadata['totalBalance'] as num?)?.toDouble() ?? 0;
    requestedMonths = (widget.metadata['requestedMonths'] as num?)?.toInt() ?? 0;

    final rawWallets = widget.metadata['wallets'];
    if (rawWallets is List) {
      wallets = rawWallets
          .map((item) => _ChatbotWallet.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } else {
      wallets = [];
    }

    final suggestedId = (widget.metadata['suggestedWalletId'] as num?)?.toInt() ?? 0;
    activeWalletIndex = wallets.indexWhere((w) => w.id == suggestedId);
    if (activeWalletIndex == -1 && wallets.isNotEmpty) {
      activeWalletIndex = 0;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  double get selectedWalletBalance {
    if (wallets.isEmpty || activeWalletIndex < 0 || activeWalletIndex >= wallets.length) {
      return 0;
    }
    return wallets[activeWalletIndex].balance;
  }

  double get initFundValue {
    if (selectedPercent == 'custom') {
      return customAmount;
    }
    final double percent = double.tryParse(selectedPercent.replaceAll('%', '')) ?? 0;
    return (selectedWalletBalance * percent / 100).floorToDouble();
  }

  void _onPercentSelected(String percent) {
    setState(() {
      selectedPercent = percent;
      if (percent != 'custom') {
        customAmount = 0;
        amountController.clear();
        amountFocusNode.unfocus();
      }
    });
  }

  void _onCustomAmountChanged(String val) {
    final cleanVal = val.replaceAll(RegExp(r'[^\d]'), '');
    final double amt = double.tryParse(cleanVal) ?? 0;

    if (amt > selectedWalletBalance) {
      setState(() {
        customAmount = selectedWalletBalance;
        amountController.text = AppHelperFunction.formatAmount(selectedWalletBalance).replaceAll('₫', '').trim();
        amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: amountController.text.length),
        );
      });
    } else {
      setState(() {
        customAmount = amt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final chatController = Get.find<ChatController>();
    final appController = Get.find<AppController>();
    final userId = appController.userId.value ?? 0;
    final isFinalized = widget.metadata['isFinalized'] == true;

    if (wallets.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colors.borderSecondary, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.savings_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MỤC TIÊU TIẾT KIỆM",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppHelperFunction.formatAmount(target),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Question Text
          Text(
            "Bạn có tổng cộng ${AppHelperFunction.formatAmount(totalBalance)} trong các ví hoạt động. Bạn có muốn trích một phần số tiền này làm vốn tích lũy ban đầu để giảm bớt áp lực tài chính hàng tháng không?",
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          // Wallets List Label
          Text(
            "Chọn ví trích tiền:",
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Wallets Horizontal Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: wallets.length,
              itemBuilder: (context, idx) {
                final wallet = wallets[idx];
                final isSelected = activeWalletIndex == idx;
                return GestureDetector(
                  onTap: isFinalized
                      ? null
                      : () {
                          setState(() {
                            activeWalletIndex = idx;
                            if (selectedPercent != 'custom') {
                              // recalculate quick percents
                            } else {
                              // limit custom amount to new wallet balance if exceeded
                              if (customAmount > wallet.balance) {
                                customAmount = wallet.balance;
                                amountController.text =
                                    AppHelperFunction.formatAmount(wallet.balance)
                                        .replaceAll('₫', '')
                                        .trim();
                              }
                            }
                          });
                        },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.06)
                          : colors.surfaceBackground.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : colors.borderSecondary,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (isSelected) ...[
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              wallet.name,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? AppColors.primary : colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppHelperFunction.formatAmount(wallet.balance),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // Percentage Selectors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['0%', '10%', '20%', '50%', 'Tùy chỉnh'].map((opt) {
              final val = opt == 'Tùy chỉnh' ? 'custom' : opt;
              final isSelected = selectedPercent == val;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: OutlinedButton(
                    onPressed: isFinalized ? null : () => _onPercentSelected(val),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : colors.cardBackground,
                      foregroundColor: isSelected ? Colors.white : colors.textPrimary,
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : colors.borderSecondary,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Custom Input Area
          if (selectedPercent == 'custom') ...[
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              focusNode: amountFocusNode,
              enabled: !isFinalized,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nhập số tiền muốn trích...',
                hintStyle: const TextStyle(fontSize: 12.5, color: Colors.grey),
                suffixText: 'VND',
                suffixStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: colors.surfaceBackground.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.borderSecondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              onChanged: _onCustomAmountChanged,
            ),
          ],

          const SizedBox(height: 16),

          // Submit / Status Section
          if (isFinalized) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.income.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.income.withOpacity(0.25)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 17,
                    color: AppColors.income,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Mục tiêu này đã được lập lộ trình",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.income,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final wallet = wallets[activeWalletIndex];
                  final fund = initFundValue;
                  final displayMsg = fund > 0
                      ? "Tôi muốn trích ${AppHelperFunction.formatAmount(fund)} từ ví ${wallet.name} để tích lũy ban đầu."
                      : "Tôi không muốn trích vốn ban đầu.";
                  final payload =
                      '/saving_goal_init_fund {"name": "$name", "target": $target, "initFund": $fund, "sourceWalletId": ${wallet.id}, "requestedMonths": $requestedMonths}';

                  chatController.sendCustomMessage(displayMsg, payload, userId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.show_chart_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      initFundValue > 0
                          ? "Trích ${AppHelperFunction.formatAmount(initFundValue)} & Xem lộ trình"
                          : "Không trích vốn & Xem lộ trình",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
