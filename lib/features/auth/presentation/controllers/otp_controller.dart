import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class OtpController extends GetxController {
  final AuthController authController;

  OtpController({required this.authController});

  final otpController = TextEditingController();
  final secondsRemaining = 60.obs;
  Timer? countdownTimer;
  RxBool get isLoading => authController.isLoading;

  List<TextInputFormatter> get otpInputFormatters => [
    LengthLimitingTextInputFormatter(6),
    FilteringTextInputFormatter.digitsOnly,
  ];

  @override
  void onInit() {
    super.onInit();
    startCountdown();
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

  void resendOtpIfAvailable() {
    if (secondsRemaining.value == 0) {
      startCountdown();
    }
  }

  Future<void> submitOtp() async {
    final result = await authController.verifyOtp(otpController.text.trim());
    result.match((failure) => AppHelperFunction.showSnackBar(failure.message), (
      message,
    ) {
      Get.offAllNamed(RoutePath.resetPassword);
      AppHelperFunction.showSnackBar(message);
    });
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
