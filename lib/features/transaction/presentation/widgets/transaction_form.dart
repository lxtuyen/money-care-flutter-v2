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
import 'package:money_care/app/widgets/button/transaction_type_toggle.dart';

class TransactionForm extends StatefulWidget {
  final String title;

  final String transactionType;
  final TransactionEntity? item;

  const TransactionForm({
    super.key,
    required this.title,
    required this.transactionType,
    this.item,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late final TransactionFormController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TransactionFormController>();
    controller.init(widget.item, widget.transactionType);
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
                      child: Obx(() => TransactionTypeToggle(
                        selected: controller.transactionType,
                        onSelected: controller.changeTransactionType,
                        showAmount: false,
                        spendLabel: 'Tiền Chi',
                        incomeLabel: 'Tiền Thu',
                        spendValue: 'expense',
                        incomeValue: 'income',
                        spendIcon: Icons.remove_circle_outline,
                        incomeIcon: Icons.add_circle_outline,
                      )),
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
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) {
                                            return Obx(() {
                                              final fundCategories = controller
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
                                                      fundCategories.isNotEmpty)
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
                                                    controller.transactionType,
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
}
