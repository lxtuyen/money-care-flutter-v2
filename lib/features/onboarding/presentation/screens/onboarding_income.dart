import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';

class OnboardingIncomeScreen extends StatefulWidget {
  const OnboardingIncomeScreen({super.key});

  @override
  State<OnboardingIncomeScreen> createState() => _OnboardingIncomeScreenState();
}

class _OnboardingIncomeScreenState extends State<OnboardingIncomeScreen> {
  final TextEditingController incomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    Future<void> onPressed() async {
      if (_formKey.currentState!.validate()) {
        try {
          final income = int.parse(incomeController.text.replaceAll(',', ''));
          await userController.addMonthlyIncome(income);

          Get.toNamed(RoutePath.main);
          AppHelperFunction.showSnackBar('Thêm thành công');
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
                      children: [TextSpan(text: AppTexts.incomeTitle)],
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: incomeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) => AppValidator.validateMonthlyIncome(value),
                  ),

                  const Spacer(),

                  Obx(() {
                    return ElevatedButton(
                      onPressed:
                          userController.isLoading.value ? null : onPressed,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child:
                          userController.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                AppTexts.done,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
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
