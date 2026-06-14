import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_form_controller.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/dialog/selection_dialog.dart';

class TransactionCoupleFields extends StatelessWidget {
  final TransactionFormController controller;

  const TransactionCoupleFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CoupleController>()) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      final coupleController = Get.find<CoupleController>();
      final coupleData = coupleController.couple.value;
      if (coupleData == null || !coupleData.isActive) {
        return const SizedBox.shrink();
      }

      final appController = Get.find<AppController>();
      final currentUserId = appController.userId.value ?? 0;
      final me = coupleData.me(currentUserId);
      final partner = coupleData.partner(currentUserId);
      final isExpense = controller.transactionType == 'expense';
      final isSharedWallet = controller.selectedWalletId.value != null &&
          coupleController.sharedWallets.any((w) => w.id == controller.selectedWalletId.value);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Payer Selection
          AppTextFormField(
            controller: controller.payerNameController,
            label: 'Người Chi Trả / Người Nhận',
            icon: Icons.person_outline_rounded,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
            ),
            hintText: 'Chọn người thanh toán',
            readOnly: true,
            validator: (v) => (v == null || v.isEmpty)
                ? 'Vui lòng chọn người thanh toán'
                : null,
            onTap: () {
              final List<SelectionOption> options = [
                if (me != null)
                  SelectionOption(
                    id: currentUserId.toString(),
                    label: '${me.fullName} (Bạn)',
                  ),
                if (partner != null)
                  SelectionOption(
                    id: partner.userId.toString(),
                    label: partner.fullName,
                  ),
              ];
              showDialog(
                context: context,
                builder: (context) => SelectionDialog(
                  title: 'Người Chi Trả / Người Nhận',
                  description: 'Chọn thành viên trả cho giao dịch này',
                  options: options,
                  initialSelectedId: controller.selectedPayerId.value?.toString(),
                  onSelect: (id, label) {
                    if (id != null && label != null) {
                      controller.setPayer(int.parse(id), label);
                    }
                  },
                ),
              );
            },
          ),

          if (isExpense) ...[
            const SizedBox(height: 20),
            // Split Method Selection
            AppTextFormField(
              controller: controller.splitMethodNameController,
              label: 'Phương thức chia tiền',
              icon: Icons.call_split_rounded,
              suffixIcon: Icon(
                isSharedWallet ? Icons.lock_outline_rounded : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
              ),
              hintText: 'Chọn phương thức chia',
              readOnly: true,
              onTap: () {
                if (isSharedWallet) {
                  Get.rawSnackbar(
                    message: 'Giao dịch từ ví chung không cần chia tiền.',
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.amber.shade900,
                  );
                  return;
                }
                final List<SelectionOption> options = [
                  SelectionOption(id: 'none', label: 'Không chia'),
                  SelectionOption(id: 'equal', label: 'Chia đều'),
                  SelectionOption(id: 'percentage', label: 'Chia theo phần trăm (%)'),
                  SelectionOption(id: 'fixed', label: 'Chia theo số tiền cố định'),
                ];
                showDialog(
                  context: context,
                  builder: (context) => SelectionDialog(
                    title: 'Phương thức chia tiền',
                    description: 'Chọn cách chia sẻ chi phí này',
                    options: options,
                    initialSelectedId: controller.splitMethod.value,
                    onSelect: (id, label) {
                      if (id != null && label != null) {
                        controller.setSplitMethod(id, label);
                      }
                    },
                  ),
                );
              },
            ),

            if (controller.splitMethod.value == 'percentage') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: controller.splitPctMeController,
                      keyboardType: TextInputType.number,
                      label: '${me?.fullName ?? "Bạn"} (%)',
                      icon: Icons.percent,
                      validator: (val) {
                        if (controller.splitMethod.value != 'percentage') return null;
                        if (val == null || val.trim().isEmpty) {
                          return 'Nhập %';
                        }
                        final numVal = double.tryParse(val.trim());
                        if (numVal == null || numVal < 0 || numVal > 100) {
                          return 'Lỗi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextFormField(
                      controller: controller.splitPctPartnerController,
                      keyboardType: TextInputType.number,
                      label: '${partner?.fullName ?? "Partner"} (%)',
                      icon: Icons.percent,
                      validator: (val) {
                        if (controller.splitMethod.value != 'percentage') return null;
                        if (val == null || val.trim().isEmpty) {
                          return 'Nhập %';
                        }
                        final numVal = double.tryParse(val.trim());
                        if (numVal == null || numVal < 0 || numVal > 100) {
                          return 'Lỗi';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],

            if (controller.splitMethod.value == 'fixed') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: controller.splitAmtMeController,
                      keyboardType: TextInputType.number,
                      label: '${me?.fullName ?? "Bạn"} (đ)',
                      icon: Icons.monetization_on_outlined,
                      validator: (val) {
                        if (controller.splitMethod.value != 'fixed') return null;
                        if (val == null || val.trim().isEmpty) {
                          return 'Nhập tiền';
                        }
                        final numVal = double.tryParse(val.trim());
                        if (numVal == null || numVal < 0) return 'Lỗi';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextFormField(
                      controller: controller.splitAmtPartnerController,
                      keyboardType: TextInputType.number,
                      label: '${partner?.fullName ?? "Partner"} (đ)',
                      icon: Icons.monetization_on_outlined,
                      validator: (val) {
                        if (controller.splitMethod.value != 'fixed') return null;
                        if (val == null || val.trim().isEmpty) {
                          return 'Nhập tiền';
                        }
                        final numVal = double.tryParse(val.trim());
                        if (numVal == null || numVal < 0) return 'Lỗi';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      );
    });
  }
}
