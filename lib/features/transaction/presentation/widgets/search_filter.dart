import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/app/widgets/icon/rounded_icon.dart';

class SearchWithFilter extends StatelessWidget {
  final String hintText;
  final VoidCallback onFilterTap;
  final VoidCallback? onClearSearch;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool hasActiveFilters;
  final int activeFilterCount;

  const SearchWithFilter({
    super.key,
    required this.onFilterTap,
    this.hintText = 'Tìm giao dịch',
    this.onClearSearch,
    this.onChanged,
    this.controller,
    this.hasActiveFilters = false,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasActiveFilters
                      ? AppColors.primary.withOpacity(0.35)
                      : AppColors.borderSecondary,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text1.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    child: const Icon(
                      Icons.search_rounded,
                      color: AppColors.text3,
                      size: 18,
                    ),
                  ),
                  suffixIcon: controller != null && controller!.text.isNotEmpty
                      ? IconButton(
                          onPressed: onClearSearch,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.text4,
                          ),
                        )
                      : null,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: AppColors.text4,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              RoundedIcon(
                applyIconRadius: true,
                iconPath: AppIcons.filter,
                height: 44,
                width: 44,
                padding: const EdgeInsets.all(8),
                backgroundColor: hasActiveFilters
                    ? AppColors.primary
                    : AppColors.backgroundPrimary,
                border: Border.all(
                  color: hasActiveFilters
                      ? AppColors.primary
                      : AppColors.borderSecondary,
                ),
                borderRadius: 14,
                color: hasActiveFilters ? Colors.white : AppColors.text2,
                onPressed: onFilterTap,
              ),
              if (hasActiveFilters)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryOrange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$activeFilterCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
