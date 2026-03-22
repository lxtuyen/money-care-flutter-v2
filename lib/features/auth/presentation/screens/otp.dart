import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  var secondsRemaining = 60.obs;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    secondsRemaining.value = 60;
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onPressed() async {
      try {
        final message = await authController.verifyOtp(otpController.text);
        Get.offAllNamed('/reset_password');
        AppHelperFunction.showSnackBar(message);
      } catch (e) {
        AppHelperFunction.showSnackBar(e.toString());
      }
    }

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
                const SizedBox(height: 80),

                const Text(
                  AppTexts.enterOtp,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppTexts.otpDescription,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.text3,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderPrimary),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: AppColors.borderPrimary),
                            ),
                          ),
                          child: const Text(
                            AppTexts.otpLabel,
                            style: TextStyle(
                              color: AppColors.text3,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: otpController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: AppTexts.otpHint,
                            hintStyle: TextStyle(
                              fontSize: 18,
                              letterSpacing: 6,
                              color: AppColors.text3,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Obx(() {
                    return RichText(
                      text: TextSpan(
                        text: AppTexts.notReceiveOtp,
                        style: const TextStyle(
                          color: AppColors.text3,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: '${secondsRemaining.value}s',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    if (secondsRemaining.value == 0) {
                                      startCountdown();
                                    }
                                  },
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                const Spacer(),

                Obx(() {
                  return ElevatedButton(
                    onPressed:
                        authController.isLoading.value ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child:
                        authController.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              AppTexts.confirmOtpButton,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                  );
                }),

                const SizedBox(height: 16),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppTexts.rememberPassword,
                      style: const TextStyle(
                        color: AppColors.text3,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: AppTexts.login,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed('/login');
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
