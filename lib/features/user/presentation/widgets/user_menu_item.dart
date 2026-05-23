import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class UserMenuItem extends StatelessWidget {
  const UserMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: AppThemeColors.of(context).textPrimary,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppThemeColors.of(context).textSecondary,
          ),
          onTap: onTap,
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppThemeColors.of(context).textMuted.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}
