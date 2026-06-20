import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/photo_transaction/presentation/controllers/photo_transaction_detail_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/photo_transaction/presentation/screens/photo_transaction_gallery_screen.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class PhotoTransactionDetailScreen extends StatelessWidget {
  final List<TransactionEntity> photoTransactions;
  final int initialIndex;
  final CoupleController? coupleController;
  final bool isPersonal;
  final int? ownerId;

  const PhotoTransactionDetailScreen({
    super.key,
    required this.photoTransactions,
    required this.initialIndex,
    this.coupleController,
    this.isPersonal = false,
    this.ownerId,
  });

  Widget _buildEditorView(
      BuildContext context, PhotoTransactionDetailController controller, PageController pageController) {
    return Column(
      children: [
        // Header title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Gallery Capsule Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (controller.hasChanges) {
                        AppConfirmDialog.show(
                          title: 'Lưu thay đổi?',
                          message:
                              'Bạn có thay đổi chưa lưu. Bạn có muốn lưu trước khi xem tất cả ảnh không?',
                          confirmText: 'Lưu',
                          cancelText: 'Hủy thay đổi',
                          onConfirm: () async {
                            final success =
                                await controller.saveChanges(closeScreen: false);
                            if (success) {
                              Get.to(
                                () => PhotoTransactionGalleryScreen(
                                  photoTransactions: controller.photoTransactions,
                                  onSelect: (index) {
                                    controller.setCurrentIndex(index);
                                    pageController.jumpToPage(index);
                                  },
                                ),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 200),
                              );
                            }
                          },
                          onCancel: () {
                            controller.resetChanges();
                            Get.to(
                              () => PhotoTransactionGalleryScreen(
                                photoTransactions: controller.photoTransactions,
                                onSelect: (index) {
                                  controller.setCurrentIndex(index);
                                  pageController.jumpToPage(index);
                                },
                              ),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 200),
                            );
                          },
                        );
                      } else {
                        Get.to(
                          () => PhotoTransactionGalleryScreen(
                            photoTransactions: controller.photoTransactions,
                            onSelect: (index) {
                              controller.setCurrentIndex(index);
                              pageController.jumpToPage(index);
                            },
                          ),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 200),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Icon(Icons.collections_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Chi tiết giao dịch',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.help_outline,
                    color: Colors.white54, size: 20),
                onPressed: () {
                  AppHelperFunction.showSuccessSnackBar(
                    'Vuốt trái/phải để chuyển giao dịch. Chạm nhãn trên ảnh để sửa.',
                  );
                },
              ),
            ],
          ),
        ),

        // Immersive Centered Photo PageView with Overlays
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. PageView for Background Image sliding
                  PageView.builder(
                    controller: pageController,
                    itemCount: controller.photoTransactions.length,
                    physics: controller.isLoading.value
                        ? const NeverScrollableScrollPhysics()
                        : const ClampingScrollPhysics(),
                    onPageChanged: (index) {
                      final prevIndex = controller.currentIndex.value;
                      if (controller.hasChanges) {
                        // Scroll back to the previous page immediately
                        pageController.jumpToPage(prevIndex);

                        // Confirm save/discard changes
                        AppConfirmDialog.show(
                          title: 'Lưu thay đổi?',
                          message:
                              'Bạn có thay đổi chưa lưu cho giao dịch này. Bạn có muốn lưu trước khi chuyển trang?',
                          confirmText: 'Lưu',
                          cancelText: 'Hủy thay đổi',
                          onConfirm: () async {
                            final success = await controller.saveChanges(closeScreen: false);
                            if (success) {
                              controller.setCurrentIndex(index);
                              pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            }
                          },
                          onCancel: () {
                            controller.resetChanges();
                            controller.setCurrentIndex(index);
                            pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                        );
                      } else {
                        controller.setCurrentIndex(index);
                      }
                    },
                    itemBuilder: (context, index) {
                      final tx = controller.photoTransactions[index];
                      final pictureUrl = tx.pictureUrl;
                      if (pictureUrl == null || pictureUrl.isEmpty) {
                        return Container(
                          color: const Color(0xFF1E1E1E),
                          child: const Icon(Icons.photo_outlined, color: Colors.white30, size: 64),
                        );
                      } else if (pictureUrl.startsWith('http')) {
                        return Image.network(
                          pictureUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF1E1E1E),
                            child: const Icon(Icons.broken_image, color: Colors.white30, size: 64),
                          ),
                        );
                      } else {
                        return Image.file(
                          File(pictureUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF1E1E1E),
                            child: const Icon(Icons.broken_image, color: Colors.white30, size: 64),
                          ),
                        );
                      }
                    },
                  ),

                  // 2. Translucent details overlays
                  AmountStickerOverlay(controller: controller),
                  PillsPanelOverlay(controller: controller, coupleController: coupleController),
                  NoteStickerOverlay(controller: controller),
                  PhotoIndexIndicatorOverlay(controller: controller),
                ],
              ),
            ),
          ),
        ),

        // Bottom Actions Bar (Hủy, Xóa và Lưu)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button (X)
              InkWell(
                onTap: () {
                  if (controller.hasChanges) {
                    AppConfirmDialog.show(
                      title: 'Hủy thay đổi?',
                      message:
                          'Bạn có thay đổi chưa lưu. Bạn có chắc chắn muốn thoát và hủy bỏ các thay đổi này?',
                      confirmText: 'Hủy thay đổi',
                      cancelText: 'Quay lại',
                      onConfirm: () => Get.back(),
                    );
                  } else {
                    Get.back();
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              // Delete Button (Trash)
              InkWell(
                onTap: () {
                  AppConfirmDialog.show(
                    title: 'Xóa giao dịch?',
                    message:
                        'Bạn có chắc chắn muốn xóa giao dịch chung này không? Thao tác này không thể hoàn tác.',
                    confirmText: 'Xóa',
                    cancelText: 'Quay lại',
                    onConfirm: () => controller.deleteTransaction(),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                ),
              ),

              // Save Button (Check)
              InkWell(
                onTap: () => controller.saveChanges(closeScreen: true),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: initialIndex);
    
    // Instantiate the controller
    final controller = Get.put(PhotoTransactionDetailController(
      photoTransactions: photoTransactions,
      initialIndex: initialIndex,
      coupleController: coupleController,
      isPersonal: isPersonal,
      ownerId: ownerId,
    ));
    
    controller.pageController = pageController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    'Đang xử lý giao dịch...',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return _buildEditorView(context, controller, pageController);
        }),
      ),
    );
  }
}

class AmountStickerOverlay extends StatelessWidget {
  final PhotoTransactionDetailController controller;
  const AmountStickerOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.showAmountSheet,
          borderRadius: BorderRadius.circular(24),
          child: Obx(() {
            final amountText = controller.amount.value > 0
                ? AppHelperFunction.formatAmount(controller.amount.value)
                : 'Nhập số tiền';
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amountText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Chạm để sửa',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PillsPanelOverlay extends StatelessWidget {
  final PhotoTransactionDetailController controller;
  final CoupleController? coupleController;

  const PillsPanelOverlay({
    super.key,
    required this.controller,
    this.coupleController,
  });

  Widget _buildGlassPill({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 6),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: Obx(() {
        final cat = controller.selectedCategory.value;
        final wallet = controller.selectedWallet.value;
        final payerName = coupleController?.couple.value?.members
                .firstWhereOrNull((m) => m.userId == controller.selectedPayerId.value)
                ?.fullName ??
            Get.find<AuthController>().user.value?.profile.fullName ?? 'Chọn...';
        final dateStr = DateFormat('dd/MM HH:mm').format(controller.selectedDate.value);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category
            _buildGlassPill(
              icon: Icons.category_outlined,
              text: cat != null ? '${cat.icon} ${cat.name}' : 'Danh mục',
              onTap: controller.showCategorySelector,
            ),
            const SizedBox(height: 8),

            // Wallet
            _buildGlassPill(
              icon: Icons.account_balance_wallet_outlined,
              text: wallet != null ? wallet.name : 'Chọn ví...',
              onTap: controller.showWalletSelector,
            ),
            const SizedBox(height: 8),

            // Payer
            if (!controller.isPersonal) ...[
              _buildGlassPill(
                icon: Icons.person_outline,
                text: 'Trả: $payerName',
                onTap: controller.showPayerSelector,
              ),
              const SizedBox(height: 8),
            ],

            // Date & Time
            _buildGlassPill(
              icon: Icons.calendar_today_outlined,
              text: dateStr,
              onTap: () => controller.selectDateTime(context),
            ),
          ],
        );
      }),
    );
  }
}

class NoteStickerOverlay extends StatelessWidget {
  final PhotoTransactionDetailController controller;
  const NoteStickerOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.showNoteSheet,
          borderRadius: BorderRadius.circular(20),
          child: Obx(() {
            final displayNote =
                controller.note.value.isEmpty ? 'Thêm ghi chú...' : controller.note.value;
            return Container(
              constraints: const BoxConstraints(maxWidth: 160),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 14),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      displayNote,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PhotoIndexIndicatorOverlay extends StatelessWidget {
  final PhotoTransactionDetailController controller;
  const PhotoIndexIndicatorOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Obx(() {
          final count = controller.photoTransactions.length;
          final current = controller.currentIndex.value;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.photo_library_outlined, color: Colors.white70, size: 12),
                const SizedBox(width: 6),
                Text(
                  '${current + 1} / $count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
