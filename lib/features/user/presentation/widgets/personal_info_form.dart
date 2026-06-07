import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/features/personalization/presentation/controllers/personalization_controller.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({super.key});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();
  final personalizationController = Get.find<PersonalizationController>();

  Future<void> onUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      final success = await userController.updateProfile();
      if (success) {
        AppHelperFunction.showSuccessSnackBar('profile.updateSuccess'.tr);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'profile.basicInfo'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: userController.firstNameController,
                    label: 'auth.firstName'.tr,
                    icon: Icons.person,
                    hintText: 'profile.nameHint'.tr,
                    validator: (v) => AppValidator.validateFirstName(v),
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: userController.lastNameController,
                    label: 'auth.lastName'.tr,
                    icon: Icons.person,
                    hintText: 'profile.lastNameHint'.tr,
                    validator: (v) => AppValidator.validateLastName(v),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    return PrimaryButton(
                      label: 'transaction.update'.tr,
                      onPressed: onUpdateProfile,
                      isLoading: userController.isLoading.value,
                      isEnabled: !userController.isLoading.value,
                    );
                  }),
                  /*Obx(() {
                    final isRebuilding = personalizationController.isRebuilding.value;
                    final p = personalizationController.profile.value;
                    final labelText = p == null ? 'Tính toán hồ sơ tài chính' : 'Tính toán lại hồ sơ';

                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: labelText,
                          onPressed: () => personalizationController.rebuildProfile(),
                          isLoading: isRebuilding,
                          isEnabled: !isRebuilding,
                        ),
                      ],
                    );
                  }),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
