import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';

class CreateSavingFund extends StatefulWidget {
  const CreateSavingFund({super.key});

  @override
  State<CreateSavingFund> createState() => _CreateSavingFundState();
}

class _CreateSavingFundState extends State<CreateSavingFund> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final SavingFundController _controller = Get.find<SavingFundController>();

  int? userId;

  final List<CategoryModel> _categories = [
    CategoryModel(icon: 'charity_icon', name: 'An uong'),
    CategoryModel(icon: 'pleasure_icon', name: 'Mua sam'),
    CategoryModel(icon: 'savings_icon', name: 'Di chuyen'),
    CategoryModel(icon: 'essential_icon', name: 'Hoa don'),
    CategoryModel(icon: 'education_icon', name: 'Giao duc'),
    CategoryModel(icon: 'freedom_icon', name: 'Khac'),
  ];

  @override
  void initState() {
    super.initState();
    initUserInfo();
  }

  Future<void> initUserInfo() async {
    final userInfoJson = LocalStorage().getUserInfo();
    if (userInfoJson == null || !mounted) return;

    final user = UserModel.fromJson(userInfoJson, '');
    setState(() {
      userId = user.id;
    });
  }

  Future<void> _createSavingFund() async {
    if (!_formKey.currentState!.validate()) return;
    if (userId == null) {
      AppHelperFunction.showSnackBar('Khong the xac dinh nguoi dung hien tai');
      return;
    }

    final totalPercentage = _categories.fold<int>(
      0,
      (sum, cat) => sum + cat.percentage,
    );

    if (totalPercentage != 100) {
      AppHelperFunction.showSnackBar(
        'Tong phan tram phai bang 100%. Hien tai la $totalPercentage%',
      );
      return;
    }

    try {
      final dto = SavingFundDto(
        categories: _categories,
        name: _nameController.text.trim(),
        id: userId,
      );
      await _controller.createFund(dto);

      if (!mounted) return;
      Get.back();
      AppHelperFunction.showSnackBar('Tao quy thanh cong');
    } catch (e) {
      AppHelperFunction.showSnackBar(e.toString());
    }
  }

  void _updateCategoryPercentage(int index, String value) {
    final category = _categories[index];
    final percentage = int.tryParse(value) ?? 0;

    setState(() {
      _categories[index] = CategoryModel(
        id: category.id,
        name: category.name,
        percentage: percentage,
        icon: category.icon,
        color: category.color,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tao quy tiet kiem'),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ten quy',
                  border: OutlineInputBorder(),
                ),
                validator: AppValidator.validateName,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/${cat.icon}.svg',
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                cat.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                key: ValueKey('${cat.name}-${cat.percentage}'),
                                initialValue: cat.percentage.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  suffixText: '%',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                                onChanged: (value) =>
                                    _updateCategoryPercentage(index, value),
                                validator: AppValidator.validatePercentage,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Obx(() {
                return ElevatedButton(
                  onPressed: _controller.isLoadingFunds.value
                      ? null
                      : _createSavingFund,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _controller.isLoadingFunds.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Tao quy',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
