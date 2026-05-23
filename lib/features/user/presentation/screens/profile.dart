import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

import 'package:money_care/app/widgets/layout/app_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();

  Future<void> onUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await userController.updateProfile();
        AppHelperFunction.showSuccessSnackBar('profile.updateSuccess'.tr);
      } catch (e) {
        AppHelperFunction.showErrorSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppHeader(
              title: 'profile.info'.tr,
              showBackButton: true,
              height: 140,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Center(
                              child: Column(
                                children: [
                                  Obx(() {
                                    final profile =
                                        userController.userProfile.value;
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        image:
                                            profile?.avatar != null &&
                                                profile!.avatar!.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  profile.avatar!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child:
                                          profile?.avatar == null ||
                                              profile!.avatar!.isEmpty
                                          ? Center(
                                              child: Text(
                                                (profile
                                                            ?.firstName
                                                            ?.isNotEmpty ==
                                                        true)
                                                    ? profile!.firstName![0]
                                                          .toUpperCase()
                                                    : "U",
                                                style: const TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            )
                                          : null,
                                    );
                                  }),
                                  const SizedBox(height: 12),
                                  Text(
                                    "profile.avatar".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.text4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'profile.basicInfo'.tr,
                              style: TextStyle(
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
                              validator: (v) =>
                                  AppValidator.validateFirstName(v),
                            ),
                            const SizedBox(height: 16),
                            AppTextFormField(
                              controller: userController.lastNameController,
                              label: 'auth.lastName'.tr,
                              icon: Icons.person,
                              hintText: 'profile.lastNameHint'.tr,
                              validator: (v) =>
                                  AppValidator.validateLastName(v),
                            ),
                            const SizedBox(height: 32),
                            Obx(() {
                              return PrimaryButton(
                                label: 'transaction.update'.tr,
                                onPressed: onUpdateProfile,
                                isLoading: userController.isLoading.value,
                                isEnabled: !userController.isLoading.value,
                              );
                            }),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
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
