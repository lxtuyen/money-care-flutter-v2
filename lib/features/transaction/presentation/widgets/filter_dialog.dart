import 'package:flutter/material.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/core/presentation/widgets/choice_chip/choice_chips.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();

    selectedId = filterController.categoryId.value?.toString();
    startDate = filterController.startDate.value;
    endDate = filterController.endDate.value;
  }

  @override
  Widget build(BuildContext context) {
    final widgets =
        widget.items != null
            ? widget.items!.map((item) {
              final bool isCustom = item.toLowerCase().contains('tùy chỉnh');
              final bool isSelected = selectedId == item;

              return CustomChoiceChip(
                text: item,
                isSelected: isSelected,
                onSelected: (selected) async {
                  if (isCustom) {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDateRange:
                          startDate != null && endDate != null
                              ? DateTimeRange(start: startDate!, end: endDate!)
                              : null,
                    );
                    if (picked != null) {
                      setState(() {
                        startDate = picked.start;
                        endDate = picked.end;
                        selectedId = item;
                      });
                    }
                  } else {
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
                    setState(() => selectedId = item);
                  }
                },
              );
            }).toList()
            : widget.categories!.map((cat) {
              final bool isSelected = selectedId == cat.id.toString();
              return CustomChoiceChip(
                text: cat.name,
                isSelected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedId = cat.id.toString();
                  });
                },
              );
            }).toList();

    return AlertDialog(
      title: Text(widget.title),
      content: Wrap(spacing: 8, runSpacing: 8, children: widgets),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedId = null;
              startDate = null;
              endDate = null;
            });

            filterController.clearAll();

            widget.onApply(
              FilterResult(selectedId: '', startDate: null, endDate: null),
            );

            Get.back();
          },
          child: const Text("Xóa lọc", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Hủy", style: TextStyle(color: AppColors.text3)),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedId != null) {
              if (widget.categories != null) {
                filterController.updateCategory(int.parse(selectedId!));
              } else {
                filterController.updateDateRange(startDate, endDate);
              }

              Get.back();
              widget.onApply(
                FilterResult(
                  selectedId: selectedId!,
                  startDate: startDate,
                  endDate: endDate,
                ),
              );
            }
          },
          child: const Text(
            "Áp dụng",
            style: TextStyle(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class FilterResult {
  final String selectedId;
  final DateTime? startDate;
  final DateTime? endDate;

  FilterResult({required this.selectedId, this.startDate, this.endDate});
}
