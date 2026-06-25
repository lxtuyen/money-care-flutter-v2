import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_insights/domain/entities/recurring_transaction_entity.dart';
import 'package:money_care/features/spending_insights/presentation/controllers/recurring_controller.dart';
import 'package:money_care/features/spending_insights/presentation/widgets/recurring_item_card.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';

class RecurringDetailScreen extends StatefulWidget {
  const RecurringDetailScreen({super.key});

  @override
  State<RecurringDetailScreen> createState() => _RecurringDetailScreenState();
}

class _RecurringDetailScreenState extends State<RecurringDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _currentTab = 0.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    final controller = Get.find<RecurringController>();
    controller.fetchConfirmed();
  }

  void _onTabChanged() {
    _currentTab.value = _tabController.index;
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecurringController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          AppHeader(
            title: 'Chi phí cố định',
            showBackButton: true,
            height: 250,
            actions: [
              Obx(() => controller.isRefreshing.value
                  ? const Padding(
                      padding: EdgeInsets.all(6),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () =>
                          controller.fetchRecurring(forceRefresh: true),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )),
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  final tabIndex = _currentTab.value;
                  final totalMonthly = controller.totalMonthlyRecurring;
                  final confirmedTotal = controller.confirmedMonthlyTotal;
                  final itemCount = controller.itemCount;
                  final confirmedCount = controller.confirmedItems.length;
                  final scannedAt = controller.lastScannedAt.value;

                  // Show amount based on active tab
                  final displayAmount = tabIndex == 0
                      ? confirmedTotal
                      : totalMonthly;
                  final displayLabel = tabIndex == 0
                      ? '$confirmedCount khoản · Hàng tháng'
                      : '$itemCount khoản · Hàng tháng';

                  String? timeText;
                  if (scannedAt != null) {
                    final dt = DateTime.tryParse(scannedAt)?.toLocal();
                    if (dt != null) {
                      final hh = dt.hour.toString().padLeft(2, '0');
                      final mm = dt.minute.toString().padLeft(2, '0');
                      timeText = 'Cập nhật lúc $hh:$mm';
                    }
                  }

                  return Column(
                    children: [
                      Text(
                        AppHelperFunction.formatAmount(displayAmount),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      if (timeText != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          timeText,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
                const SizedBox(height: 8),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Đã xác nhận'),
                    Tab(text: 'Phát hiện mới'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.hasError.value) {
                return _buildError(controller);
              }

              return _buildBody(controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(RecurringController controller) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildConfirmedTab(controller),
        _buildDetectedTab(controller),
      ],
    );
  }



  Widget _buildConfirmedTab(RecurringController controller) {
    return Obx(() {
      if (controller.isLoadingConfirmed.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final items = controller.confirmedItems;
      if (items.isEmpty) {
        return const AppEmptyState(
          message: 'Chưa có khoản nào được xác nhận\nVuốt sang phải các khoản phát hiện mới để xác nhận',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return RecurringItemCard(
            item: item,
            isConfirmed: true,
            onTap: () => _showConfirmedActions(context, controller, item),
          );
        },
      );
    });
  }

  void _showConfirmedActions(
    BuildContext context,
    RecurringController controller,
    RecurringTransactionEntity item,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppHelperFunction.formatAmount(item.averageAmount),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
                title: const Text('Sửa số tiền'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditAmountDialog(context, controller, item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                title: const Text('Sửa ngày nhắc'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditDayDialog(context, controller, item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: AppColors.expense),
                title: const Text('Xóa khoản chi', style: TextStyle(color: AppColors.expense)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteConfirm(context, controller, item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditAmountDialog(
    BuildContext context,
    RecurringController controller,
    RecurringTransactionEntity item,
  ) {
    final textController = TextEditingController(
      text: item.averageAmount.toStringAsFixed(0),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          16, 12, 16,
          MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sửa số tiền',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            AppCurrencyFormField(
              controller: textController,
              label: 'Số tiền',
              icon: Icons.payments_rounded,
              hintText: 'Nhập số tiền',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final raw = AppHelperFunction.unformatCurrency(
                    textController.text,
                  );
                  final newAmount = double.tryParse(raw);
                  if (newAmount != null && newAmount > 0) {
                    Navigator.pop(ctx);
                    controller.updateConfirmed(item, {
                      'averageAmount': newAmount,
                      'monthlyEstimate': newAmount,
                    });
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDayDialog(
    BuildContext context,
    RecurringController controller,
    RecurringTransactionEntity item,
  ) {
    int selectedDay = item.expectedDay ?? 1;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chọn ngày nhắc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 31,
                  itemBuilder: (_, index) {
                    final day = index + 1;
                    final isSelected = selectedDay == day;
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedDay = day),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color:
                                isSelected ? Colors.white : AppColors.text1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      controller.updateConfirmed(
                        item,
                        {'expectedDay': selectedDay},
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirm(
    BuildContext context,
    RecurringController controller,
    RecurringTransactionEntity item,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa khoản chi'),
        content: Text(
          'Bạn có chắc muốn xóa "${item.description}"?\n'
          'AI có thể phát hiện lại khoản này trong lần scan tiếp theo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.expense,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteConfirmed(item);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedTab(RecurringController controller) {
    return Obx(() {
      final items = controller.recurringItems;

      if (items.isEmpty) {
        return const AppEmptyState(
          message: 'Chưa phát hiện chi phí lặp lại nào',
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildDismissibleItem(controller, item);
          },
        ),
      );
    });
  }

  Widget _buildDismissibleItem(
    RecurringController controller,
    RecurringTransactionEntity item,
  ) {
    return Dismissible(
      key: ValueKey(item.recurringId),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await controller.confirmItem(item);
        } else {
          await controller.dismissItem(item);
        }
        return false; // controller handles removal
      },
      background: _buildSwipeBackground(
        color: AppColors.success,
        icon: Icons.check_rounded,
        label: 'Xác nhận',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeBackground(
        color: AppColors.expense,
        icon: Icons.close_rounded,
        label: 'Bỏ qua',
        alignment: Alignment.centerRight,
      ),
      child: RecurringItemCard(item: item),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (alignment == Alignment.centerRight) ...[
            const SizedBox(width: 6),
            Icon(icon, color: color, size: 22),
          ],
        ],
      ),
    );
  }

  Widget _buildError(RecurringController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.text5),
          const SizedBox(height: 12),
          const Text(
            'Không thể tải dữ liệu',
            style: TextStyle(fontSize: 14, color: AppColors.text4),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchRecurring(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
