import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/features/user/presentation/widgets/profile_header.dart';
import 'package:money_care/features/user/presentation/widgets/personal_info_form.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppHeader(
              title: 'profile.info'.tr,
              showBackButton: true,
              height: 120,
            ),
            const Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ProfileHeader(),
                    SizedBox(height: 16),
                    PersonalInfoForm(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
