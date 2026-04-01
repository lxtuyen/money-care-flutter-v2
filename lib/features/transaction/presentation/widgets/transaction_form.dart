import 'package:flutter/material.dart';
import 'package:money_care/core/presentation/widgets/layout/app_header.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_form_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';

class TransactionForm extends StatefulWidget {
  final String title;
  final bool showCategory;
  final TransactionEntity? item;

  const TransactionForm({
    super.key,
    required this.title,
    this.showCategory = true,
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
    controller.init(widget.showCategory, widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                          Get.back();
                        } else {
                          Get.toNamed(RoutePath.main);
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
                                  label: 'Ngày giao dịch',
                                  placeholder: 'Chọn ngày',
                                  onTap: () => controller.selectDate(context),
                                ),
                                const SizedBox(height: 20),
                                AppCurrencyFormField(
                                  controller: controller.amountController,
                                  label: 'Số tiền',
                                  icon: Icons.attach_money,
                                  hintText: 'Nhập số tiền',
                                  validator:
                                      (v) => AppValidator.validateAmount(v),
                                ),
                                if (widget.showCategory) ...[
                                  const SizedBox(height: 20),
                                  AppTextFormField(
                                    controller: controller.categoryController,
                                    label: 'Phân loại',
                                    icon: Icons.category,
                                    hintText: 'Chọn phân loại',
                                    validator:
                                        (v) => AppValidator.validateCategory(v),
                                    onTap: () async {
                                      final selected = await showModalBottomSheet<
                                        CategoryEntity
                                      >(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) {
                                          return Obx(() {
                                            if (controller
                                                .savingFundController
                                                .isLoadingCurrent
                                                .value) {
                                              return const SizedBox(
                                                height: 200,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            } else if (controller
                                                    .savingFundController
                                                    .currentFund
                                                    .value ==
                                                null) {
                                              return const SizedBox(
                                                height: 200,
                                                child: Center(
                                                  child: Text(
                                                    'Không có dữ liệu',
                                                  ),
                                                ),
                                              );
                                            }

                                            final categories =
                                                controller
                                                    .savingFundController
                                                    .currentFund
                                                    .value!
                                                    .categories;

                                            return CategorySheet(
                                              categories: categories,
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
                                  label: 'Ghi chú',
                                  hintText: 'Nhập ghi chú',
                                  validator:
                                      (v) => AppValidator.validateNote(v),
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
                    if (widget.showCategory)
                      Obx(
                        () => GestureDetector(
                          onTap:
                              controller.scanReceiptController.isScanning.value
                                  ? null
                                  : () => controller.openScanOptions(context),
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.borderPrimary,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                controller
                                        .scanReceiptController
                                        .isScanning
                                        .value
                                    ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.document_scanner_outlined,
                                      color: Colors.grey,
                                    ),
                          ),
                        ),
                      ),
                    if (widget.showCategory) const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() {
                        return PrimaryButton(
                          label: widget.item?.id == null ? 'Tạo' : 'Cập nhật',
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
}
