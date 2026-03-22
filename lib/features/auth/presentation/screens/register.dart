import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Future<void> onPressed() async {
      if (_formKey.currentState!.validate()) {
        try {
          final message = await authController.register(
            emailController.text,
            passwordController.text,
            firstNameController.text,
            lastNameController.text,
          );

          Get.offAllNamed('/login');

          AppHelperFunction.showSnackBar(message);
        } catch (e) {
           AppHelperFunction.showSnackBar(e.toString());
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  const Text(
                    AppTexts.signup,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    AppTexts.registerSubtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text3,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: AppTexts.firstName,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            return AppValidator.validateFirstName(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: AppTexts.lastName,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            return AppValidator.validateLastName(value);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 25),

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
                                AppTexts.signup,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                    );
                  }),

                  const SizedBox(height: 25),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppTexts.alreadyHaveAccount,
                        style: const TextStyle(
                          color: AppColors.text3,
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
      ),
    );
  }
}
