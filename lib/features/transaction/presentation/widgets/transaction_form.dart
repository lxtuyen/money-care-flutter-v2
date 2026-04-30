import 'package:flutter/material.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_form_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class TransactionForm extends StatefulWidget {
  final String title;
  final bool showCategory;
  final bool isRecurring;
  final bool showTypeSelector;
  final void Function(CreateRecurringTransactionDto dto)? onRecurringSubmit;

  /// 'income' hoặc 'expense' — dùng để filter category đúng loại.
  final String transactionType;
  final TransactionEntity? item;

  const TransactionForm({
    super.key,
    required this.title,
    required this.transactionType,
    this.showCategory = true,
    this.isRecurring = false,
    this.showTypeSelector = false,
    this.onRecurringSubmit,
    this.item,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late final TransactionFormController controller;
  late String selectedTransactionType;
  String selectedFrequency = 'monthly';

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
                      height: 165,
                      showBackButton: true,
                      onBackTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Get.offAllNamed(RoutePath.main);
                        }
                      },
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
                                if (widget.showTypeSelector) ...[
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('Chi'),
                                          value: 'expense',
                                          groupValue: selectedTransactionType,
                                          onChanged: (v) {
                                            if (v == null) return;
                                            setState(() {
                                              selectedTransactionType = v;
                                              controller.transactionType = v;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('Thu'),
                                          value: 'income',
                                          groupValue: selectedTransactionType,
                                          onChanged: (v) {
                                            if (v == null) return;
                                            setState(() {
                                              selectedTransactionType = v;
                                              controller.transactionType = v;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (widget.isRecurring) ...[
                                  const SizedBox(height: 20),
                                  DropdownButtonFormField<String>(
                                    value: selectedFrequency,
                                    decoration: const InputDecoration(
                                      labelText: 'Tần suất',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'daily',
                                        child: Text('Hàng ngày'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'weekly',
                                        child: Text('Hàng tuần'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'monthly',
                                        child: Text('Hàng tháng'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'yearly',
                                        child: Text('Hàng năm'),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() {
                                        selectedFrequency = v;
                                      });
                                    },
                                  ),
                                ],
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
                          label: widget.isRecurring
                              ? 'transaction.create'.tr
                              : (widget.item?.id == null
                                    ? 'transaction.create'.tr
                                    : 'transaction.update'.tr),
                          onPressed: widget.isRecurring
                              ? () {
                                  if (!controller.formKey.currentState!
                                      .validate()) {
                                    return;
                                  }

                                  if (widget.onRecurringSubmit != null) {
                                    try {
                                      widget.onRecurringSubmit!.call(
                                        controller.buildRecurringTransactionDto(
                                          selectedFrequency,
                                        ),
                                      );
                                    } catch (e) {
                                      AppHelperFunction.showErrorSnackBar(
                                        e.toString(),
                                      );
                                    }
                                  }
                                }
                              : controller.submit,
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
}
