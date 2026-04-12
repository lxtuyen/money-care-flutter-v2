import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/choice_chip/choice_chips.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.title,
    this.items,
    this.categories,
    required this.onApply,
  });

  final String title;
  final List<String>? items;
  final List<CategoryEntity>? categories;
  final ValueChanged<FilterResult> onApply;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final FilterController filterController = Get.find<FilterController>();

  String? selectedId;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedDateLabel;

  bool get isDateDialog => widget.items != null;

  @override
  void initState() {
    super.initState();

    if (isDateDialog) {
      selectedId = filterController.dateLabel.value;
      selectedDateLabel = filterController.dateLabel.value;
    } else {
      selectedId = filterController.categoryId.value?.toString();
    }

    startDate = filterController.startDate.value;
    endDate = filterController.endDate.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isDateDialog
                              ? Icons.calendar_month_rounded
                              : Icons.category_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isDateDialog
                        ? 'Chọn mốc thời gian phù hợp để xem giao dịch chính xác hơn.'
                        : 'Thu hẹp danh sách giao dịch theo phân loại bạn muốn xem.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
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
                        color: AppColors.backgroundPrimary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _buildSummaryText(),
                        style: const TextStyle(
                          color: AppColors.text3,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _buildChoiceWidgets(),
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
                    child: OutlinedButton(
                      onPressed: _clearFilter,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.borderSecondary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Xóa lọc'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applySelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
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

  List<Widget> _buildChoiceWidgets() {
    if (isDateDialog) {
      return widget.items!.map((item) {
        final isCustom = item.toLowerCase().contains('tùy chỉnh');
        final isSelected = selectedId == item;

        return CustomChoiceChip(
          text: item,
          isSelected: isSelected,
          onSelected: (selected) async {
            if (!selected) {
              setState(() => selectedId = null);
              return;
            }

            if (isCustom) {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange:
                    startDate != null && endDate != null
                        ? DateTimeRange(start: startDate!, end: endDate!)
                        : null,
              );

              if (picked == null) return;

              setState(() {
                startDate = picked.start;
                endDate = picked.end;
                selectedId = item;
                selectedDateLabel = item;
              });
              return;
            }

            final now = DateTime.now();
            if (item == 'Hôm nay') {
              startDate = DateTime(now.year, now.month, now.day);
              endDate = startDate!
                  .add(const Duration(days: 1))
                  .subtract(const Duration(seconds: 1));
            } else if (item == 'Tuần này') {
              final weekday = now.weekday;
              startDate = DateTime(
                now.year,
                now.month,
                now.day,
              ).subtract(Duration(days: weekday - 1));
              endDate = startDate!
                  .add(const Duration(days: 7))
                  .subtract(const Duration(seconds: 1));
            } else if (item == 'Tháng này') {
              startDate = DateTime(now.year, now.month, 1);
              endDate = DateTime(
                now.year,
                now.month + 1,
                1,
              ).subtract(const Duration(seconds: 1));
            }

            setState(() {
              selectedId = item;
              selectedDateLabel = item;
            });
          },
        );
      }).toList().cast<Widget>();
    }

    return widget.categories!.map((cat) {
      final isSelected = cat.id != null && selectedId == cat.id.toString();
      return CustomChoiceChip(
        text: cat.name,
        isSelected: isSelected,
        onSelected: (selected) {
          if (cat.id == null) return;
          setState(() {
            selectedId = selected ? cat.id.toString() : null;
          });
        },
      );
    }).toList().cast<Widget>();
  }

  String _buildSummaryText() {
    if (isDateDialog) {
      return selectedDateLabel != null
          ? 'Đang chọn: $selectedDateLabel'
          : 'Chưa chọn khoảng thời gian';
    }

    if (selectedId != null && widget.categories != null) {
      try {
        final cat = widget.categories!.firstWhere((c) => c.id.toString() == selectedId);
        return 'Đã chọn: ${cat.name}';
      } catch (_) {
        return 'Đã chọn 1 phân loại giao dịch';
      }
    }
    
    return 'Chưa chọn phân loại nào';
  }

  void _clearFilter() {
    setState(() {
      selectedId = null;
      startDate = null;
      endDate = null;
      selectedDateLabel = null;
    });

    filterController.clearAll();
    widget.onApply(
      FilterResult(selectedId: '', startDate: null, endDate: null),
    );
    Get.back();
  }

  void _applySelection() {
    if (widget.categories != null) {
      filterController.updateCategory(
        selectedId != null ? int.tryParse(selectedId!) : null,
      );
    } else {
      if (selectedId == null || startDate == null || endDate == null) {
        return;
      }

      filterController.updateDateRange(
        startDate,
        endDate,
        label: selectedDateLabel ?? selectedId,
      );
    }

    Get.back();
    widget.onApply(
      FilterResult(
        selectedId: selectedId ?? '',
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }
}

class FilterResult {
  final String selectedId;
  final DateTime? startDate;
  final DateTime? endDate;

  FilterResult({required this.selectedId, this.startDate, this.endDate});
}
