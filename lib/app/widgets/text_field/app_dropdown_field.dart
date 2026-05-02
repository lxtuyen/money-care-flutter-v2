import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData? icon;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final bool enabled;

  const AppDropdownField({
    super.key,
    this.value,
    required this.label,
    this.icon,
    required this.items,
    this.onChanged,
    this.validator,
    this.selectedItemBuilder,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      selectedItemBuilder: selectedItemBuilder,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      style: const TextStyle(
        color: AppColors.text1,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.text3),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      menuMaxHeight: 300,
      elevation: 4,
      isExpanded: true,
      itemHeight: null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.secondaryNavyBlue, size: 22)
            : null,
        isDense: true,
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        labelStyle: const TextStyle(
          color: AppColors.text3,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        border: _buildBorder(AppColors.borderSecondary),
        enabledBorder: _buildBorder(AppColors.borderSecondary),
        focusedBorder: _buildBorder(AppColors.primary, 1.8),
        errorBorder: _buildBorder(AppColors.error),
        disabledBorder: _buildBorder(AppColors.disabled),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, [double width = 1.2]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}
