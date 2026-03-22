import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/presentation/widgets/icon/rounded_icon.dart';

class SearchWithFilter extends StatelessWidget {
  final String hintText;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchWithFilter({
    super.key,
    required this.onFilterTap,
    this.hintText = 'Tìm giao dịch',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.text4),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderSecondary,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderPrimary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          RoundedIcon(
            applyIconRadius: true,
            iconPath: AppIcons.filter,
            height: 24,
            width: 24,
            color: AppColors.text2,
            onPressed: onFilterTap,
          ),
        ],
      ),
    );
  }
}
