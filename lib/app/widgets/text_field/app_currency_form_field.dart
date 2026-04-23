import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class AppCurrencyFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final IconData icon;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onRawChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextStyle? hintStyle;

  const AppCurrencyFormField({
    super.key,
    this.controller,
    required this.label,
    required this.icon,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.onChanged,
    this.onRawChanged,
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

  @override
  State<AppCurrencyFormField> createState() => _AppCurrencyFormFieldState();
}

class _AppCurrencyFormFieldState extends State<AppCurrencyFormField> {
  bool _isSyncingController = false;

  InputDecoration _inputDecoration() {
    const borderRadius = BorderRadius.all(Radius.circular(18));

    OutlineInputBorder buildBorder(Color color, [double width = 1.2]) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      hintStyle:
          widget.hintStyle ??
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
      prefixIcon: Icon(
        widget.icon,
        color: AppColors.secondaryNavyBlue,
        size: 22,
      ),
      suffixIcon: widget.suffixIcon,
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
  void initState() {
    super.initState();
    widget.controller?.addListener(_syncControllerText);
    _syncControllerText();
  }

  @override
  void didUpdateWidget(covariant AppCurrencyFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_syncControllerText);
      widget.controller?.addListener(_syncControllerText);
      _syncControllerText();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_syncControllerText);
    super.dispose();
  }

  void _syncControllerText() {
    final controller = widget.controller;
    if (controller == null || _isSyncingController) return;

    final rawValue = AppHelperFunction.unformatCurrency(controller.text);
    final formattedValue = AppHelperFunction.formatCurrency(rawValue);

    if (controller.text == formattedValue) return;

    _isSyncingController = true;
    controller.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
    _isSyncingController = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: _inputDecoration(),
      style: const TextStyle(
        color: AppColors.text1,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.number,
      obscureText: widget.obscureText,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onChanged: (value) {
        widget.onChanged?.call(value);
        widget.onRawChanged?.call(AppHelperFunction.unformatCurrency(value));
      },
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _ThousandsSeparatorInputFormatter(),
        ...?widget.inputFormatters,
      ],
      textAlign: widget.textAlign,
      cursorColor: AppColors.primary,
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _numberFormat = NumberFormat.decimalPattern(
    'vi_VN',
  );

  static String formatRaw(String value) {
    return AppHelperFunction.formatCurrency(value);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawValue = AppHelperFunction.unformatCurrency(newValue.text);
    final formattedValue = formatRaw(rawValue);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
      composing: TextRange.empty,
    );
  }
}
