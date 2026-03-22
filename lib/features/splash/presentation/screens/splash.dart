import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNext();
  }

  Future<void> _decideNext() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final hasLoggedIn = prefs.getBool('hasLoggedIn') ?? false;
    final hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    if (!hasSeenOnboarding) {
      Get.offAllNamed('/onboarding_expense_management');
    } else if (!hasLoggedIn) {
      Get.offAllNamed('/select_method_login');
    } else if (!hasSeenWelcome) {
      Get.offAllNamed('/onboarding_welcome');
    } else {
      Get.offAllNamed('/main');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primary,
    body: Center(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(seconds: 1),
        child: Image.asset(AppImages.splash, width: 100),
      ),
    ),
  );
}
