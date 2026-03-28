import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';

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
          final rawValue = AppCurrencyFormField.unformat(incomeController.text);
          final income = int.parse(rawValue);
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

                  AppCurrencyFormField(
                    controller: incomeController,
                    label: 'Thu nhập hàng tháng',
                    icon: Icons.attach_money,
                    hintText: 'VD: 5.000.000',
                    validator: (v) => AppValidator.validateMonthlyIncome(v),
                  ),

                  const SizedBox(height: 20),

                  Obx(() {
                    return PrimaryButton(
                      label: AppTexts.done,
                      onPressed: onPressed,
                      isLoading: userController.isLoading.value,
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
