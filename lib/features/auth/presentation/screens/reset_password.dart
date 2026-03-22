import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Future<void> onPressed() async {
      if (_formKey.currentState!.validate()) {
        try {
          final message = await authController.resetPassword(
            passwordController.text,
          );
          Get.offAllNamed(RoutePath.login);
          AppHelperFunction.showSnackBar(message);
        } catch (e) {
          AppHelperFunction.showSnackBar(e.toString());
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

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text1,
                      ),
                      children: [TextSpan(text: AppTexts.resetPasswordTitle)],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    AppTexts.resetPasswordDescription,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text3,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

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

                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: AppTexts.confirmPasswordLabel,
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
                    obscureText: _isObscure,
                    keyboardType: TextInputType.visiblePassword,
                    validator:
                        (value) => AppValidator.validateConfirmPassword(
                          passwordController.text,
                          value,
                        ),
                  ),

                  const SizedBox(height: 10),

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
                                AppTexts.confirmButton,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppTexts.rememberPassword,
                        style: const TextStyle(
                          color: AppColors.text4,
                          fontSize: 18,
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
                                    Get.toNamed(RoutePath.login);
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
