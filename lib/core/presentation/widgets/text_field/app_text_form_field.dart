import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_care/core/constants/colors.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? icon;
  final String? hintText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextStyle? hintStyle;

  const AppTextFormField({
    super.key,
    this.controller,
    required this.label,
    this.icon,
    this.hintText,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.enabled = true,
    this.autovalidateMode,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.hintStyle,
  });

  InputDecoration _inputDecoration() {
    const borderRadius = BorderRadius.all(Radius.circular(18));

    OutlineInputBorder buildBorder(Color color, [double width = 1.2]) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      labelText: label,
      hintText: hintText,
      hintStyle:
          hintStyle ??
          const TextStyle(
            color: AppColors.text4,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
      labelStyle: const TextStyle(
        color: AppColors.text3,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: icon != null ? Icon(icon, color: AppColors.secondaryNavyBlue, size: 22) : null,
      suffixIcon: suffixIcon,
      isDense: true,
      filled: true,
      fillColor: AppColors.backgroundSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: buildBorder(AppColors.borderSecondary),
      focusedBorder: buildBorder(AppColors.primary, 1.8),
      errorBorder: buildBorder(AppColors.error),
      focusedErrorBorder: buildBorder(AppColors.error, 1.8),
      disabledBorder: buildBorder(AppColors.disabled),
      border: buildBorder(AppColors.borderSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(),
      style: const TextStyle(
        color: AppColors.text1,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      cursorColor: AppColors.primary,
    );
  }
}
