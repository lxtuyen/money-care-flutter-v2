import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/enums.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/app/widgets/appbar/appbar.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

import 'package:money_care/core/theme/app_theme_colors.dart';

class DashboardCustomizationScreen extends StatefulWidget {
  const DashboardCustomizationScreen({super.key});

  @override
  State<DashboardCustomizationScreen> createState() =>
      _DashboardCustomizationScreenState();
}

class _DashboardCustomizationScreenState
    extends State<DashboardCustomizationScreen> {
  final AppController appController = Get.find<AppController>();
  late List<DashboardSection> _activeSections;
  late List<DashboardSection> _inactiveSections;

  @override
  void initState() {
    super.initState();
    _activeSections = List.from(appController.dashboardSections);
    _inactiveSections = DashboardSection.values
        .where((s) => !_activeSections.contains(s))
        .toList();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final DashboardSection item = _activeSections.removeAt(oldIndex);
      _activeSections.insert(newIndex, item);
    });
  }

  void _toggleSection(DashboardSection section, bool isActive) {
    setState(() {
      if (isActive) {
        _inactiveSections.remove(section);
        _activeSections.add(section);
      } else {
        _activeSections.remove(section);
        _inactiveSections.add(section);
      }
    });
  }

  void _save() {
    appController.updateDashboardSections(_activeSections);
    AppHelperFunction.showSuccessSnackBar('dashboard.saveSuccess'.tr);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = appController.isDarkMode.value;

    return Scaffold(
      appBar: AppbarCustom(
        title: Text(
          'dashboard.customizeTitle'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        showBackArrow: true,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'common.save'.tr,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'dashboard.customizeDesc'.tr,
              style: const TextStyle(color: AppColors.text4, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildActiveList(isDark),
            const SizedBox(height: 30),
            if (_inactiveSections.isNotEmpty) ...[
              const Text(
                'Ẩn khỏi Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: 12),
              _buildInactiveList(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActiveList(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.of(context).cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _activeSections.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final section = _activeSections[index];
          return _buildSectionTile(section, true, index, isDark);
        },
      ),
    );
  }

  Widget _buildInactiveList(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.of(context).cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _inactiveSections.length,
        itemBuilder: (context, index) {
          final section = _inactiveSections[index];
          return _buildSectionTile(section, false, index, isDark);
        },
      ),
    );
  }

  Widget _buildSectionTile(
    DashboardSection section,
    bool isActive,
    int index,
    bool isDark,
  ) {
    return ListTile(
      key: ValueKey(section),
      leading: isActive
          ? const Icon(Icons.drag_handle_rounded, color: AppColors.text4)
          : null,
      title: Text(
        'dashboard.section.${section.name}'.tr,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isActive ? AppColors.text1 : AppColors.text4,
        ),
      ),
      trailing: Switch.adaptive(
        value: isActive,
        activeColor: AppColors.primary,
        onChanged: (val) => _toggleSection(section, val),
      ),
    );
  }
}
