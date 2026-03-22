import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController monthlyIncomeController;

  @override
  void initState() {
    super.initState();
    final user = userController.userProfile.value;

    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    monthlyIncomeController = TextEditingController(
      text: user?.monthlyIncome?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    monthlyIncomeController.dispose();
    super.dispose();
  }

  Future<void> onUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dto = ProfileUpdateDto(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          monthlyIncome: int.parse(
            monthlyIncomeController.text.replaceAll(',', ''),
          ),
        );
        await userController.updateProfile(dto);
        AppHelperFunction.showSnackBar('Cập nhật thành công');
      } catch (e) {
        AppHelperFunction.showSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        showBackArrow: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Hồ sơ của bạn",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "Tên",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => AppValidator.validateFirstName(v),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Họ",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => AppValidator.validateLastName(v),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: monthlyIncomeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Thu nhập hàng tháng",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => AppValidator.validateMonthlyIncome(v),
                  ),
                  const SizedBox(height: 24),

                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            userController.isLoading.value
                                ? null
                                : onUpdateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            userController.isLoading.value
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Cập nhật",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
