import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:image_picker/image_picker.dart';

import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/scan_receipt_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/widgets/sheet/category_sheet.dart';

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
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int? selectedCategoryId;

  final TransactionController transactionController =
      Get.find<TransactionController>();
  final SavingFundController savingFundController =
      Get.find<SavingFundController>();
  final ScanReceiptController scanReceiptController =
      Get.find<ScanReceiptController>();
  final AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      final item = widget.item!;
      selectedDate = item.transactionDate!;
      _amountController.text = item.amount.toString();
      _categoryController.text = item.category?.name ?? "";
      _noteController.text = item.note ?? "";
      selectedCategoryId = item.category?.id;
    }
  }

  Future<void> _openScanOptions() async {
    if (scanReceiptController.isScanning.value) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Chụp hoá đơn'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Chọn từ thư viện'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;
    await _scanBill(source);
  }

  Future<void> _scanBill(ImageSource source) async {
    final data = await scanReceiptController.scan(source);
    if (data != null) {
      setState(() {
        _amountController.text = data.totalAmount.toString();
        selectedDate = DateTime.parse(data.date);
        if (widget.showCategory) {
          final categories =
              savingFundController.currentFund.value?.categories ?? [];

          final matched = categories.firstWhere(
            (c) =>
                c.name.toLowerCase().trim() ==
                data.categoryName.toLowerCase().trim(),
            orElse: () => CategoryEntity(id: -1, name: "", icon: "default.png"),
          );

          if (matched.id != -1) {
            selectedCategoryId = matched.id;
            _categoryController.text = matched.name;
          }
        }
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  TransactionCreateDto _buildTransactionDto() {
    return TransactionCreateDto(
      amount: int.tryParse(_amountController.text) ?? 0,
      type: widget.showCategory ? "expense" : "income",
      note: _noteController.text.trim(),
      categoryId: selectedCategoryId,
      transactionDate: selectedDate,
      userId: appController.userId.value ?? 0,
    );
  }

  Future<void> _showCategorySheet(BuildContext context) async {
    final selected = await showModalBottomSheet<CategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Obx(() {
          if (savingFundController.isLoadingCurrent.value) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (savingFundController.currentFund.value == null) {
            return const SizedBox(
              height: 200,
              child: Center(child: Text('Không có dữ liệu')),
            );
          }

          final categories = savingFundController.currentFund.value!.categories;

          return CategorySheet(categories: categories);
        });
      },
    );

    if (selected != null) {
      setState(() {
        selectedCategoryId = selected.id;
        _categoryController.text = selected.name;
      });
    }
  }

  Future<void> _createTransaction() async {
    try {
      final dto = _buildTransactionDto();
      await transactionController.createTransaction(dto);
      Get.back();
      AppHelperFunction.showSnackBar('Tạo giao dịch thành công');
    } catch (e) {
      AppHelperFunction.showSnackBar(e.toString());
    }
  }

  Future<void> _updateTransaction() async {
    try {
      final dto = _buildTransactionDto();
      await transactionController.updateTransaction(dto, widget.item!.id!);
      Get.back();
      AppHelperFunction.showSnackBar('Cập nhật giao dịch thành công');
    } catch (e) {
      AppHelperFunction.showSnackBar(e.toString());
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 160),
              child: Column(
                children: [
                  Container(
                    height: 165,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Get.back();
                              } else {
                                Get.toNamed(RoutePath.main);
                              }
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _selectDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.borderPrimary,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            AppHelperFunction.getFormattedDate(
                                              selectedDate,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextFormField(
                                controller: _amountController,
                                decoration: InputDecoration(
                                  labelText: "Số tiền",
                                  hintText: "Nhập số tiền",
                                  prefixIcon: const Icon(Icons.attach_money),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        AppValidator.validateAmount(value),
                              ),

                              if (widget.showCategory) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Phân loại',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _categoryController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Phân loại',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  ),
                                  validator:
                                      (value) =>
                                          AppValidator.validateCategory(value),
                                  onTap: () => _showCategorySheet(context),
                                ),
                              ],

                              const SizedBox(height: 20),

                              TextFormField(
                                controller: _noteController,
                                decoration: InputDecoration(
                                  labelText: "Ghi chú",
                                  hintText: "Nhập ghi chú (không bắt buộc)",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                validator:
                                    (value) => AppValidator.validateNote(value),
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

            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (widget.showCategory)
                        GestureDetector(
                          onTap:
                              scanReceiptController.isScanning.value
                                  ? null
                                  : _openScanOptions,
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
                                scanReceiptController.isScanning.value
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
                      if (widget.showCategory) const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          return ElevatedButton(
                            onPressed:
                                widget.item?.id != null
                                    ? _updateTransaction
                                    : _createTransaction,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child:
                                transactionController.isLoading.value
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      widget.item?.id == null
                                          ? 'Tạo'
                                          : 'Cập nhật',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
