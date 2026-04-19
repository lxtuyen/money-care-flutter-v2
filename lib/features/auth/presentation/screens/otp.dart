import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/features/auth/presentation/controllers/otp_controller.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_header.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_redirect_text.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: AppTexts.enterOtp,
                  subtitle: AppTexts.otpDescription,
                  titleFontSize: 28,
                  spacing: 8,
                ),
                const SizedBox(height: 30),
                AppTextFormField(
                  controller: controller.otpController,
                  label: AppTexts.otpLabel,
                  icon: Icons.password_rounded,
                  hintText: AppTexts.otpHint,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  inputFormatters: controller.otpInputFormatters,
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 6,
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Obx(() {
                    return AuthRedirectText(
                      leadingText: AppTexts.notReceiveOtp,
                      actionText: '${controller.secondsRemaining.value}s',
                      fontSize: 16,
                      onTap: controller.resendOtpIfAvailable,
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return PrimaryButton(
                    label: AppTexts.confirmOtpButton,
                    onPressed: controller.submitOtp,
                    isLoading: controller.isLoading.value,
                  );
                }),
                const Spacer(),
                AuthRedirectText(
                  leadingText: AppTexts.rememberPassword,
                  actionText: AppTexts.login,
                  onTap: () {
                    Get.toNamed(RoutePath.login);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


