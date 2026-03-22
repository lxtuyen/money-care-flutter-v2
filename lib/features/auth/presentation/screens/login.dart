import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Future<void> onPressed() async {
      if (_formKey.currentState!.validate()) {
        await authController.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        final user = authController.user.value;
        if (user == null) {
          AppHelperFunction.showSnackBar('Đăng nhập thất bại');
          return;
        }
        if (user.role == 'user') {
          Get.offAllNamed(
            user.savingFund != null ? '/main' : '/onboarding_welcome',
          );
          return;
        }

        if (user.role == 'admin') {
          Get.offAllNamed('/admin/home');
          return;
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                  const SizedBox(height: 80),
                  const Text(
                    AppTexts.login,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    AppTexts.loginSubtitle,
                    style: TextStyle(fontSize: 15, color: AppColors.text1),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: AppTexts.emailLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => AppValidator.validateEmail(value),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: AppTexts.passwordLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),

                      filled: true,
                      fillColor: Colors.white,
                    ),

                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    validator: (value) => AppValidator.validatePassword(value),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/forgot_password');
                      },
                      child: const Text(
                        AppTexts.forgotPassword,
                        style: TextStyle(color: AppColors.text3, fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

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
                                AppTexts.login,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                    );
                  }),

                  const Spacer(),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppTexts.noAccount,
                        style: const TextStyle(
                          color: AppColors.text3,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: AppTexts.signup,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed('/register');
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
      ),
    );
  }
}
