import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/student_profile/domain/entities/student_profile_entity.dart';
import 'package:money_care/features/student_profile/presentation/controllers/student_profile_controller.dart';

/// Screen for viewing and editing the student profile.
///
/// Requirements: 2.1, 2.2, 2.3, 2.4, 2.5
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentProfileController>();

    return Scaffold(
      appBar: AppbarCustom(
        showBackArrow: true,
        title: const Text(
          'Hồ sơ sinh viên',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text1,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _ProfileForm(controller: controller);
      }),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  final StudentProfileController controller;

  const _ProfileForm({required this.controller});

  Future<void> _onSave(BuildContext context) async {
    final success = await controller.save();
    if (success) {
      AppHelperFunction.showSuccessSnackBar('Hồ sơ đã được lưu thành công');
    } else if (controller.studyYearError.value == null &&
        controller.monthlyIncomeError.value == null) {
      AppHelperFunction.showErrorSnackBar('Không thể lưu hồ sơ. Vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Thông tin học tập',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cập nhật thông tin để nhận gợi ý ngân sách phù hợp',
              style: TextStyle(fontSize: 14, color: AppColors.text4),
            ),
            const SizedBox(height: 24),

            // University
            AppTextFormField(
              controller: controller.universityController,
              label: 'Tên trường',
              icon: Icons.school_outlined,
              hintText: 'VD: Đại học Bách Khoa',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Faculty
            AppTextFormField(
              controller: controller.facultyController,
              label: 'Tên khoa',
              icon: Icons.account_balance_outlined,
              hintText: 'VD: Khoa Công nghệ Thông tin',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Study Year with inline error (Req 2.3)
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFormField(
                  controller: controller.studyYearController,
                  label: 'Năm học',
                  icon: Icons.calendar_today_outlined,
                  hintText: 'VD: 1',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.next,
                  onChanged: controller.onStudyYearChanged,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                if (controller.studyYearError.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Text(
                      controller.studyYearError.value!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            )),
            const SizedBox(height: 16),

            // Monthly Income with inline error (Req 2.4)
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFormField(
                  controller: controller.monthlyIncomeController,
                  label: 'Thu nhập hàng tháng (VNĐ)',
                  icon: Icons.attach_money_outlined,
                  hintText: 'VD: 3000000',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                  onChanged: controller.onMonthlyIncomeChanged,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                if (controller.monthlyIncomeError.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Text(
                      controller.monthlyIncomeError.value!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            )),
            const SizedBox(height: 16),

            // Income Date picker
            Obx(() => _IncomeDateField(
              incomeDate: controller.incomeDate.value,
              onTap: () => controller.pickIncomeDate(context),
            )),
            const SizedBox(height: 24),

            // Exam Periods section (Req 9.1)
            _ExamPeriodsSection(controller: controller),
            const SizedBox(height: 32),

            // Save button
            Obx(() => PrimaryButton(
              label: 'Lưu hồ sơ',
              onPressed: () => _onSave(context),
              isLoading: controller.isLoading.value,
              isEnabled: !controller.isLoading.value,
            )),
            const SizedBox(height: 24),
          ],
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

/// Section for managing exam periods (Req 9.1).
class _ExamPeriodsSection extends StatelessWidget {
  final StudentProfileController controller;

  const _ExamPeriodsSection({required this.controller});

  Future<void> _showAddExamPeriodDialog(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;
    String? errorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Thêm kỳ thi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: Text(
                      startDate != null
                          ? 'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(startDate!)}'
                          : 'Chọn ngày bắt đầu',
                      style: TextStyle(
                        color: startDate != null ? AppColors.text1 : AppColors.text4,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                          errorText = null;
                        });
                      }
                    },
                  ),
                  // End date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_outlined),
                    title: Text(
                      endDate != null
                          ? 'Kết thúc: ${DateFormat('dd/MM/yyyy').format(endDate!)}'
                          : 'Chọn ngày kết thúc',
                      style: TextStyle(
                        color: endDate != null ? AppColors.text1 : AppColors.text4,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                          errorText = null;
                        });
                      }
                    },
                  ),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        errorText!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    if (startDate == null || endDate == null) {
                      setState(() {
                        errorText = 'Vui lòng chọn cả ngày bắt đầu và kết thúc';
                      });
                      return;
                    }
                    if (!endDate!.isAfter(startDate!)) {
                      setState(() {
                        errorText = 'Ngày kết thúc phải sau ngày bắt đầu';
                      });
                      return;
                    }
                    controller.addExamPeriod(
                      ExamPeriod(startDate: startDate!, endDate: endDate!),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kỳ thi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text1,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddExamPeriodDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Thêm kỳ thi'),
            ),
          ],
        ),
        Obx(() {
          if (controller.examPeriods.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Chưa có kỳ thi nào',
                style: TextStyle(fontSize: 14, color: AppColors.text4),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.examPeriods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final period = controller.examPeriods[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.secondaryNavyBlue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_note_outlined,
                      size: 18,
                      color: AppColors.secondaryNavyBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${DateFormat('dd/MM/yyyy').format(period.startDate)} – ${DateFormat('dd/MM/yyyy').format(period.endDate)}',
                        style: const TextStyle(fontSize: 14, color: AppColors.text1),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.error,
                      ),
                      onPressed: () => controller.removeExamPeriod(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
