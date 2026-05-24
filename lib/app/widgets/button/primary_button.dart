import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;

    final Widget child = isLoading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: canPress ? Colors.white : Colors.grey[600],
            ),
          );

    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      backgroundColor: canPress ? AppColors.primary : Colors.grey[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: canPress ? 4 : 0,
    );

    if (icon != null && !isLoading) {
      return ElevatedButton.icon(
        onPressed: canPress ? onPressed : null,
        style: buttonStyle,
        icon: icon!,
        label: child,
      );
    }

    return ElevatedButton(
      onPressed: canPress ? onPressed : null,
      style: buttonStyle,
      child: child,
    );
  }
}
