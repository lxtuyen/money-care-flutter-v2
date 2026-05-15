import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/recommendation/data/models/place_checkin_model.dart';
import 'package:money_care/features/recommendation/presentation/services/place_checkin_service.dart';

class CheckinPlaceManagementScreen extends StatefulWidget {
  const CheckinPlaceManagementScreen({super.key});

  @override
  State<CheckinPlaceManagementScreen> createState() =>
      _CheckinPlaceManagementScreenState();
}

class _CheckinPlaceManagementScreenState
    extends State<CheckinPlaceManagementScreen> {
  final PlaceCheckinService service = Get.find<PlaceCheckinService>();
  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  List<PlaceCheckinModel> checkins = [];

  @override
  void initState() {
    super.initState();
    _loadCheckins();
  }

  Future<void> _loadCheckins() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final result = await service.getMyCheckins();
      if (!mounted) return;
      setState(() => checkins = result);
    } catch (error) {
      if (!mounted) return;
      setState(() => errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  List<PlaceCheckinModel> get filteredCheckins {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return checkins;
    return checkins.where((checkin) {
      final place = checkin.place;
      return place.name.toLowerCase().contains(query) ||
          place.address.toLowerCase().contains(query) ||
          (checkin.note ?? '').toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _deleteCheckin(PlaceCheckinModel checkin) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xóa check-in?'),
        content: Text('Bạn muốn xóa check-in tại ${checkin.place.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await service.deleteCheckin(checkin.id);
      AppHelperFunction.showSuccessSnackBar('Đã xóa check-in');
      await _loadCheckins();
    } catch (error) {
      AppHelperFunction.showErrorSnackBar(error.toString());
    }
  }

  Future<void> _editCheckin(PlaceCheckinModel checkin) async {
    final updated = await showModalBottomSheet<PlaceCheckinModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditCheckinSheet(checkin: checkin, service: service),
    );
    if (updated == null) return;
    await _loadCheckins();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredCheckins;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(
              title: 'Quản lý check-in',
              showBackButton: true,
              height: 140,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên địa điểm, địa chỉ, ghi chú...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadCheckins,
                child: _buildBody(items),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<PlaceCheckinModel> items) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.error_outline_rounded, size: 40),
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.expense),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _loadCheckins,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Thử lại'),
          ),
        ],
      );
    }

    if (items.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.place_outlined, size: 48, color: AppColors.text4),
          const SizedBox(height: 12),
          Text(
            searchController.text.trim().isEmpty
                ? 'Bạn chưa có địa điểm check-in nào.'
                : 'Không tìm thấy check-in phù hợp.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.text4),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _CheckinTile(
          checkin: items[index],
          onEdit: () => _editCheckin(items[index]),
          onDelete: () => _deleteCheckin(items[index]),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class _CheckinTile extends StatelessWidget {
  const _CheckinTile({
    required this.checkin,
    required this.onEdit,
    required this.onDelete,
  });

  final PlaceCheckinModel checkin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final place = checkin.place;
    final date = checkin.visitedAt == null
        ? ''
        : AppHelperFunction.getFormattedDate(checkin.visitedAt!);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        leading: const Icon(
          Icons.place_rounded,
          color: AppColors.secondaryNavyBlue,
        ),
        title: Text(
          place.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (place.address.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(place.address, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 6),
            Wrap(
              spacing: 10,
              runSpacing: 4,
              children: [
                _MetaText(
                  icon: Icons.star_rounded,
                  text: '${checkin.rating}/5',
                ),
                _MetaText(
                  icon: Icons.payments_outlined,
                  text: AppHelperFunction.formatAmount(
                    checkin.amount.toDouble(),
                  ),
                ),
                if (date.isNotEmpty)
                  _MetaText(icon: Icons.event_outlined, text: date),
                _MetaText(
                  icon: checkin.wantToReturn
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  text: checkin.wantToReturn ? 'Muốn quay lại' : 'Không chắc',
                ),
              ],
            ),
            if (checkin.note?.isNotEmpty == true) ...[
              const SizedBox(height: 6),
              Text(
                checkin.note!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.text4),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Sửa')),
            PopupMenuItem(value: 'delete', child: Text('Xóa')),
          ],
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.text4),
        const SizedBox(width: 3),
        Text(text, style: TextStyle(fontSize: 12, color: AppColors.text4)),
      ],
    );
  }
}

class _EditCheckinSheet extends StatefulWidget {
  const _EditCheckinSheet({required this.checkin, required this.service});

  final PlaceCheckinModel checkin;
  final PlaceCheckinService service;

  @override
  State<_EditCheckinSheet> createState() => _EditCheckinSheetState();
}

class _EditCheckinSheetState extends State<_EditCheckinSheet> {
  late final TextEditingController noteController;
  late int rating;
  late bool wantToReturn;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    rating = widget.checkin.rating;
    wantToReturn = widget.checkin.wantToReturn;
    noteController = TextEditingController(text: widget.checkin.note ?? '');
  }

  Future<void> _save() async {
    if (isSaving) return;
    setState(() => isSaving = true);
    try {
      final updated = await widget.service.updateCheckin(
        id: widget.checkin.id,
        rating: rating,
        wantToReturn: wantToReturn,
        note: noteController.text.trim(),
      );
      AppHelperFunction.showSuccessSnackBar('Đã cập nhật check-in');
      Get.back(result: updated);
    } catch (error) {
      AppHelperFunction.showErrorSnackBar(error.toString());
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.checkin.place.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Đánh giá'),
                const SizedBox(width: 8),
                ...List.generate(5, (index) {
                  final value = index + 1;
                  return IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => rating = value),
                    icon: Icon(
                      value <= rating ? Icons.star : Icons.star_border,
                      color: Colors.amber.shade700,
                    ),
                  );
                }),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: wantToReturn,
              onChanged: (value) => setState(() => wantToReturn = value),
              title: const Text('Muốn quay lại lần sau'),
            ),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Lưu thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
