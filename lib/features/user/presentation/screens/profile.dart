import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';

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

  @override
  void initState() {
    super.initState();
    final user = userController.userProfile.value;

    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> onUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dto = ProfileUpdateDto(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
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

                  AppTextFormField(
                    controller: firstNameController,
                    label: 'Tên',
                    icon: Icons.person,
                    hintText: 'VD: Văn A',
                    validator: (v) => AppValidator.validateFirstName(v),
                  ),
                  const SizedBox(height: 16),

                  AppTextFormField(
                    controller: lastNameController,
                    label: 'Họ',
                    icon: Icons.person,
                    hintText: 'VD: Nguyễn',
                    validator: (v) => AppValidator.validateLastName(v),
                  ),
                  const SizedBox(height: 24),

                  Obx(() {
                    return PrimaryButton(
                      label: 'Cập nhật',
                      onPressed: onUpdateProfile,
                      isLoading: userController.isLoading.value,
                      isEnabled: !userController.isLoading.value,
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
