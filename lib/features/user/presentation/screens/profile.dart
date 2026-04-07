import 'package:intl/intl.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/features/gamification/presentation/widgets/badges_section_widget.dart';
import 'package:money_care/features/onboarding/presentation/widgets/complete_setup_banner_widget.dart';

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
        AppHelperFunction.showSuccessSnackBar('Cập nhật thành công');
      } catch (e) {
        AppHelperFunction.showErrorSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(showBackArrow: true),
      body: SingleChildScrollView(
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
                    const SizedBox(height: 40),
                    const Text(
                      "Hồ sơ của bạn",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const CompleteSetupBannerWidget(),

                    const Text(
                      'Thông tin cơ bản',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: 16),

                    AppTextFormField(
                      controller: userController.firstNameController,
                      label: 'Tên',
                      icon: Icons.person,
                      hintText: 'VD: Văn A',
                      validator: (v) => AppValidator.validateFirstName(v),
                    ),
                    const SizedBox(height: 16),

                    AppTextFormField(
                      controller: userController.lastNameController,
                      label: 'Họ',
                      icon: Icons.person,
                      hintText: 'VD: Nguyễn',
                      validator: (v) => AppValidator.validateLastName(v),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Thông tin tài chính',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: 16),

                    AppTextFormField(
                      controller: userController.monthlyIncomeController,
                      label: 'Thu nhập hàng tháng (VNĐ)',
                      icon: Icons.attach_money_outlined,
                      hintText: 'VD: 3000000',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    Obx(() => _IncomeDateField(
                          incomeDate: userController.incomeDate.value,
                          onTap: () => userController.pickIncomeDate(context),
                        )),

                    const SizedBox(height: 32),

                    Obx(() {
                      return PrimaryButton(
                        label: 'Cập nhật',
                        onPressed: onUpdateProfile,
                        isLoading: userController.isLoading.value,
                        isEnabled: !userController.isLoading.value,
                      );
                    }),

                    const SizedBox(height: 32),

                    const BadgesSectionWidget(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IncomeDateField extends StatelessWidget {
  final DateTime? incomeDate;
  final VoidCallback onTap;

  const _IncomeDateField({required this.incomeDate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final displayText = incomeDate != null
        ? DateFormat('dd/MM/yyyy').format(incomeDate!)
        : '';

    return AppTextFormField(
      label: 'Ngày nhận tiền hàng tháng',
      icon: Icons.event_outlined,
      hintText: 'Chọn ngày',
      controller: TextEditingController(text: displayText),
      readOnly: true,
      onTap: onTap,
      suffixIcon: const Icon(
        Icons.arrow_drop_down,
        color: AppColors.secondaryNavyBlue,
      ),
    );
  }
}
