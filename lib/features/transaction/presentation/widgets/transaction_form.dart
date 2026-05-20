import 'package:flutter/material.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_form_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';
import 'package:money_care/app/widgets/dialog/selection_dialog.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/constants/colors.dart';

class TransactionForm extends StatefulWidget {
  final String title;
  final bool showCategory;
  final bool showTypeSelector;

  final String transactionType;
  final TransactionEntity? item;

  const TransactionForm({
    super.key,
    required this.title,
    required this.transactionType,
    this.showCategory = true,
    this.showTypeSelector = false,
    this.item,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late final TransactionFormController controller;
  late String selectedTransactionType;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TransactionFormController>();
    selectedTransactionType = widget.transactionType;
    controller.init(widget.showCategory, widget.item, selectedTransactionType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppHeader(
                      title: widget.title,
                      height: 220,
                      showBackButton: true,
                      onBackTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Get.offAllNamed(RoutePath.main);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _buildHeaderToggleCard(
                              label: 'Tiền Chi',
                              icon: Icons.remove_circle_outline,
                              isActive: selectedTransactionType == 'expense',
                              onTap: () => _onTypeChanged('expense'),
                            ),
                            const SizedBox(width: 12),
                            _buildHeaderToggleCard(
                              label: 'Tiền Thu',
                              icon: Icons.add_circle_outline,
                              isActive: selectedTransactionType == 'income',
                              onTap: () => _onTypeChanged('income'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DatePickerField(
                                  selectedDate: controller.selectedDate,
                                  label: 'transaction.dateLabel'.tr,
                                  placeholder: 'transaction.dateHint'.tr,
                                  onTap: () => controller.selectDate(context),
                                ),
                                const SizedBox(height: 20),
                                AppCurrencyFormField(
                                  controller: controller.amountController,
                                  label: 'transaction.amount'.tr,
                                  icon: Icons.attach_money,
                                  hintText: 'transaction.amountHint'.tr,
                                  validator: (v) =>
                                      AppValidator.validateAmount(v),
                                ),
                                const SizedBox(height: 20),
                                AppTextFormField(
                                  controller: controller.walletNameController,
                                  label: 'transaction.walletLabel'.tr,
                                  icon: Icons.account_balance_wallet,
                                  suffixIcon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.text3,
                                  ),
                                  hintText: 'transaction.walletHint'.tr,
                                  readOnly: true,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'transaction.walletRequired'.tr
                                      : null,
                                  onTap: () {
                                    final wallets =
                                        controller.walletController.wallets;
                                    showDialog(
                                      context: context,
                                      builder: (context) => SelectionDialog(
                                        title:
                                            'transaction.walletSelectionTitle',
                                        description:
                                            'transaction.walletSelectionDesc',
                                        options: wallets
                                            .map(
                                              (w) => SelectionOption(
                                                id: w.id.toString(),
                                                label: w.name,
                                              ),
                                            )
                                            .toList(),
                                        initialSelectedId: controller
                                            .selectedWalletId
                                            .value
                                            ?.toString(),
                                        onSelect: (id, label) {
                                          if (id != null) {
                                            final wallet = wallets.firstWhere(
                                              (w) => w.id.toString() == id,
                                            );
                                            controller.setWallet(
                                              wallet.id,
                                              wallet.name,
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                                if (widget.showCategory) ...[
                                  const SizedBox(height: 20),
                                  AppTextFormField(
                                    controller: controller.categoryController,
                                    label: 'transaction.category'.tr,
                                    icon: Icons.category,
                                    hintText: 'transaction.categoryHint'.tr,
                                    validator: (v) =>
                                        AppValidator.validateCategory(v),
                                    onTap: () async {
                                      final selected =
                                          await showModalBottomSheet<
                                            CategoryEntity
                                          >(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: AppThemeColors.of(
                                              context,
                                            ).cardBackground,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                            ),
                                            builder: (context) {
                                              return Obx(() {
                                                final fundCategories =
                                                    controller
                                                        .savingGoalController
                                                        .currentGoal
                                                        .value
                                                        ?.categories;

                                                final userCategoryController =
                                                    Get.find<
                                                      UserCategoryController
                                                    >();

                                                final categories =
                                                    (fundCategories != null &&
                                                        fundCategories
                                                            .isNotEmpty)
                                                    ? fundCategories
                                                    : userCategoryController
                                                          .categories;

                                                if (controller
                                                    .savingGoalController
                                                    .isLoadingCurrent
                                                    .value) {
                                                  return const SizedBox(
                                                    height: 200,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                }

                                                if (categories.isEmpty) {
                                                  return const SizedBox(
                                                    height: 200,
                                                    child: Center(
                                                      child: Text(
                                                        'Chưa có danh mục nào',
                                                      ),
                                                    ),
                                                  );
                                                }

                                                return CategorySheet(
                                                  categories: categories,
                                                  transactionType:
                                                      selectedTransactionType,
                                                  selectedCategoryInit:
                                                      controller
                                                              .selectedCategoryId
                                                              .value !=
                                                          null
                                                      ? categories.firstWhereOrNull(
                                                          (c) =>
                                                              c.id ==
                                                              controller
                                                                  .selectedCategoryId
                                                                  .value,
                                                        )
                                                      : null,
                                                );
                                              });
                                            },
                                          );

                                      if (selected != null) {
                                        controller.setCategory(selected);
                                      }
                                    },
                                    readOnly: true,
                                  ),
                                  _buildSubCategoryField(),
                                ],
                                const SizedBox(height: 20),
                                AppTextFormField(
                                  controller: controller.noteController,
                                  label: 'transaction.note'.tr,
                                  hintText: 'transaction.noteHint'.tr,
                                  validator: (v) =>
                                      AppValidator.validateNote(v),
                                  minLines: 3,
                                  maxLines: 3,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return PrimaryButton(
                          label: widget.item?.id == null
                              ? 'transaction.create'.tr
                              : 'transaction.update'.tr,
                          onPressed: controller.submit,
                          isLoading:
                              controller.transactionController.isLoading.value,
                          isEnabled:
                              !controller.transactionController.isLoading.value,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTypeChanged(String type) {
    setState(() {
      selectedTransactionType = type;
      controller.transactionType = type;
      controller.selectedCategoryId.value = null;
      controller.selectedSubCategoryId.value = null;
      controller.selectedCategory = null;
      controller.categoryController.clear();
      controller.subCategoryController.clear();
    });
  }

  Widget _buildSubCategoryField() {
    return Obx(() {
      final subCategories =
          controller.selectedCategory?.subCategories ?? const [];
      if (subCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          AppTextFormField(
            controller: controller.subCategoryController,
            label: 'Danh mục con',
            icon: Icons.account_tree_outlined,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
            ),
            hintText: 'Chọn danh mục con',
            readOnly: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SelectionDialog(
                  title: 'Danh mục con',
                  description: 'Chọn nhóm chi tiết cho giao dịch',
                  clearButtonText: 'common.delete',
                  options: subCategories
                      .where((item) => item.id != null)
                      .map(
                        (item) => SelectionOption(
                          id: item.id.toString(),
                          label:
                              '${item.icon.isNotEmpty ? '${item.icon} ' : ''}${item.name}',
                        ),
                      )
                      .toList(),
                  initialSelectedId: controller.selectedSubCategoryId.value
                      ?.toString(),
                  onSelect: (id, label) {
                    final selected = subCategories.firstWhereOrNull(
                      (item) => item.id?.toString() == id,
                    );
                    controller.setSubCategory(selected);
                  },
                ),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildHeaderToggleCard({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 70,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.24)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
