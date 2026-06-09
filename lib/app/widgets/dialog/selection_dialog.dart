import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/app_outline_button.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/choice_chip/choice_chips.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

class SelectionOption {
  final String id;
  final String label;

  SelectionOption({required this.id, required this.label});
}

class SelectionDialog extends StatefulWidget {
  const SelectionDialog({
    super.key,
    required this.title,
    required this.description,
    required this.options,
    this.initialSelectedId,
    required this.onSelect,
    this.summaryPrefix = 'Đã chọn: ',
    this.noSelectionText = 'Chưa chọn mục nào',
    this.clearButtonText,
  });

  final String title;
  final String description;
  final List<SelectionOption> options;
  final String? initialSelectedId;
  final void Function(String? id, String? label) onSelect;
  final String summaryPrefix;
  final String noSelectionText;
  final String? clearButtonText;

  @override
  State<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  String? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.initialSelectedId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppThemeColors.of(context).cardBackground,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: const BoxDecoration(
                gradient: AppColors.linearGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title.tr,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.description.tr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppThemeColors.of(context).surfaceBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _buildSummaryText(),
                        style: TextStyle(
                          color: AppThemeColors.of(context).textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: widget.options.map((option) {
                        final isSelected = selectedId == option.id;
                        return CustomChoiceChip(
                          text: option.label.tr,
                          isSelected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedId = selected ? option.id : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: AppOutlineButton(
                      label: '',
                      onPressed: () {
                        setState(() => selectedId = null);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(
                          color: AppColors.borderSecondary,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        (widget.clearButtonText ?? 'common.clearFilter').tr,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'common.apply'.tr,
                      onPressed: () {
                        final selectedOption = widget.options.firstWhereOrNull(
                          (o) => o.id == selectedId,
                        );
                        widget.onSelect(selectedId, selectedOption?.label);
                        Get.back();
                      },
                      height: 48,
                      fontSize: 14,
                      borderRadius: 16,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSummaryText() {
    if (selectedId != null) {
      final option = widget.options.firstWhereOrNull((o) => o.id == selectedId);
      if (option != null) {
        return '${widget.summaryPrefix}${option.label.tr}';
      }
    }
    return widget.noSelectionText.tr;
  }
}
