import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';

class PhotoTransactionHistoryScreen extends StatefulWidget {
  const PhotoTransactionHistoryScreen({super.key});

  @override
  State<PhotoTransactionHistoryScreen> createState() =>
      _PhotoTransactionHistoryScreenState();
}

class _PhotoTransactionHistoryScreenState
    extends State<PhotoTransactionHistoryScreen> {
  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final FundController fundController = Get.find<FundController>();

  // 'all' | 'expense' | 'income'
  String _selectedType = 'all';
  bool _isLoading = false;
  List<TransactionEntity> _allPhotoTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final userId = await appController.getCurrentUserId();
      if (userId == null) return;

      await transactionController.filterTransactions(
        userId,
        TransactionFilterDto(
          fundId:
              fundController.fundId.value > 0
                  ? fundController.fundId.value
                  : null,
        ),
      );

      final data = transactionController.transactionByfilter.value;
      if (data != null) {
        final all = [
          ...data.expenseTransactions,
          ...data.incomeTransactions,
        ].where((t) => t.pictureUrl != null && t.pictureUrl!.isNotEmpty).toList();

        all.sort((a, b) {
          final da = a.transactionDate ?? DateTime(0);
          final db = b.transactionDate ?? DateTime(0);
          return db.compareTo(da);
        });

        setState(() => _allPhotoTransactions = all);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<TransactionEntity> get _filtered {
    if (_selectedType == 'all') return _allPhotoTransactions;
    return _allPhotoTransactions
        .where((t) => t.type == (_selectedType == 'expense' ? 'expense' : 'income'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          AppHeader(
            title: 'Lịch sử ảnh',
            showBackButton: true,
            height: 160,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _TypeFilterBar(
                selected: _selectedType,
                onChanged: (v) => setState(() => _selectedType = v),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: _buildGrid(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final items = _filtered;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _PhotoCard(
        item: items[i],
        onTap: () => _showDetail(items[i]),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              size: 38,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa có bản ghi kèm ảnh',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Các giao dịch có ảnh sẽ hiển thị ở đây',
            style: TextStyle(fontSize: 13, color: AppColors.text4),
          ),
        ],
      ),
    );
  }

  void _showDetail(TransactionEntity item) {
    showDialog(
      context: context,
      builder: (_) => TransactionDetail(
        item: item,
        isExpense: item.type == 'expense',
        userId: appController.userId.value ?? 0,
      ),
    );
  }
}

// ─── Type Filter Bar ──────────────────────────────────────────────────────────

class _TypeFilterBar extends StatelessWidget {
  const _TypeFilterBar({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _Tab(label: 'Tất cả', value: 'all', selected: selected, onTap: onChanged),
          _Tab(label: 'Chi', value: 'expense', selected: selected, onTap: onChanged),
          _Tab(label: 'Thu', value: 'income', selected: selected, onTap: onChanged),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.primary : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Photo Card ───────────────────────────────────────────────────────────────

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.item, required this.onTap});

  final TransactionEntity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isExpense = item.type == 'expense';
    final typeColor = isExpense ? AppColors.secondaryOrange : AppColors.success;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: _buildImage(),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isExpense ? 'Chi' : 'Thu',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: typeColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (item.transactionDate != null)
                        Text(
                          _formatDate(item.transactionDate!),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.text5,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppHelperFunction.formatAmount(
                      item.amount.toDouble(),
                      'VND',
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.note != null && item.note!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.note!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.text4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = item.pictureUrl!;
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover, width: double.infinity);
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.backgroundPrimary,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.text5,
          size: 32,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
