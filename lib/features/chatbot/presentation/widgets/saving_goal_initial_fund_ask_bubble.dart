import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/controllers/chat_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/chatbot/domain/entities/entities.dart';
import 'package:money_care/app/widgets/button/app_outline_button.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

class SavingGoalInitialFundAskBubble extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const SavingGoalInitialFundAskBubble({super.key, required this.metadata});

  @override
  State<SavingGoalInitialFundAskBubble> createState() =>
      _SavingGoalInitialFundAskBubbleState();
}

class _SavingGoalInitialFundAskBubbleState
    extends State<SavingGoalInitialFundAskBubble> {
  late ChatSavingGoalInitialFundAskEntity model;

  int activeWalletIndex = 0;
  double customAmount = 0;
  String selectedPercent = '0%'; // '0%', '10%', '20%', '50%', 'custom'
  final TextEditingController amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    model = ChatSavingGoalInitialFundAskEntity.fromMap(widget.metadata);

    final idx = model.wallets.indexWhere(
      (w) => w.id == model.suggestedWalletId,
    );
    activeWalletIndex = idx != -1 ? idx : 0;
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  double get selectedWalletBalance => activeWalletIndex < model.wallets.length
      ? model.wallets[activeWalletIndex].balance
      : 0;

  double get initFundValue {
    if (selectedPercent == 'custom') return customAmount;
    final percent = double.tryParse(selectedPercent.replaceAll('%', '')) ?? 0;
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
        amountController.text = AppHelperFunction.formatAmount(
          selectedWalletBalance,
        ).replaceAll('₫', '').trim();
        amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: amountController.text.length),
        );
      });
    } else {
      final formatted = AppHelperFunction.formatCurrency(cleanVal);
      setState(() {
        customAmount = amt;
        if (amountController.text != formatted) {
          amountController.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final chatController = Get.find<ChatController>();
    final appController = Get.find<AppController>();
    final userId = appController.userId.value ?? 0;

    if (model.wallets.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                  color: AppColors.primary.withValues(alpha: 0.08),
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
                      model.name,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppHelperFunction.formatAmount(model.target),
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
            "Bạn có tổng cộng ${AppHelperFunction.formatAmount(model.totalBalance)} trong các ví hoạt động. Bạn có muốn trích một phần số tiền này làm vốn tích lũy ban đầu để giảm bớt áp lực tài chính hàng tháng không?",
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
              itemCount: model.wallets.length,
              itemBuilder: (context, idx) {
                final wallet = model.wallets[idx];
                final isSelected = activeWalletIndex == idx;
                return GestureDetector(
                  onTap: model.isFinalized
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
                                    AppHelperFunction.formatAmount(
                                      wallet.balance,
                                    ).replaceAll('₫', '').trim();
                              }
                            }
                          });
                        },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.06)
                          : colors.surfaceBackground.withValues(alpha: 0.3),
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
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : colors.textPrimary,
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
                  child: AppOutlineButton(
                    label: opt,
                    isSelected: isSelected,
                    onPressed: model.isFinalized
                        ? null
                        : () => _onPercentSelected(val),
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
              enabled: !model.isFinalized,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nhập số tiền muốn trích...',
                hintStyle: const TextStyle(fontSize: 12.5, color: Colors.grey),
                suffixText: 'VND',
                suffixStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colors.textSecondary,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: colors.surfaceBackground.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.borderSecondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: _onCustomAmountChanged,
            ),
          ],

          const SizedBox(height: 16),

          // Submit / Status Section
          if (model.isFinalized) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.income.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.income.withValues(alpha: 0.25),
                ),
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
            PrimaryButton(
              label: initFundValue > 0
                  ? "Trích ${AppHelperFunction.formatAmount(initFundValue)} & Xem lộ trình"
                  : "Không trích vốn & Xem lộ trình",
              onPressed: () {
                final wallet = model.wallets[activeWalletIndex];
                final fund = initFundValue;
                final displayMsg = fund > 0
                    ? "Tôi muốn trích ${AppHelperFunction.formatAmount(fund)} từ ví ${wallet.name} để tích lũy ban đầu."
                    : "Tôi không muốn trích vốn ban đầu.";
                final payload =
                    '/saving_goal_init_fund {"name": "${model.name}", "target": ${model.target}, "initFund": $fund, "sourceWalletId": ${wallet.id}, "requestedMonths": ${model.requestedMonths}}';

                chatController.sendCustomMessage(displayMsg, payload, userId);
              },
              height: 48,
              fontSize: 13,
              borderRadius: 14,
              elevation: 0,
            ),
          ],
        ],
      ),
    );
  }
}
