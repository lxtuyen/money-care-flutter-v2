import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/photo_transaction/presentation/controllers/photo_transaction_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class PhotoTransactionScreen extends StatelessWidget {
  final XFile? image;
  final CoupleController? coupleController;
  final bool isPersonal;
  final int? ownerId;

  const PhotoTransactionScreen({
    super.key,
    this.image,
    this.coupleController,
    this.isPersonal = false,
    this.ownerId,
  });

  Widget _buildGlassPill({
    IconData? icon,
    required String text,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isLocked 
                ? Colors.black.withValues(alpha: 0.3) 
                : Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLocked ? Colors.white10 : Colors.white12,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon, 
                  color: isLocked ? Colors.white38 : Colors.white, 
                  size: 14,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                text,
                style: TextStyle(
                  color: isLocked ? Colors.white38 : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white38,
                  size: 12,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraView(BuildContext context, PhotoTransactionController controller) {
    return Column(
      children: [
        // Camera Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () => Get.back(),
              ),
              const Text(
                'Chụp ảnh giao dịch',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() => IconButton(
                icon: Icon(
                  controller.flashMode.value == FlashMode.off
                      ? Icons.flash_off_rounded
                      : controller.flashMode.value == FlashMode.always
                          ? Icons.flash_on_rounded
                          : controller.flashMode.value == FlashMode.auto
                              ? Icons.flash_auto_rounded
                              : Icons.flashlight_on_rounded,
                  color: controller.flashMode.value == FlashMode.off ? Colors.white54 : const Color(0xFFFFB703),
                  size: 22,
                ),
                onPressed: controller.toggleFlash,
              )),
            ],
          ),
        ),

        // Viewfinder
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Obx(() {
                    if (controller.isCameraInitialized.value &&
                        controller.cameraController != null &&
                        controller.cameraController!.value.isInitialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.cameraController!.value.previewSize!.height,
                          height: controller.cameraController!.value.previewSize!.width,
                          child: CameraPreview(controller.cameraController!),
                        ),
                      );
                    } else if (controller.isPermissionDenied.value) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.no_photography_outlined,
                                color: Colors.white54,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Không thể truy cập camera',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Vui lòng cấp quyền truy cập camera trong cài đặt thiết bị để sử dụng tính năng này.',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: controller.initCamera,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                child: const Text('Thử lại', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),

        // Bottom Actions Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gallery Picker Button (Left)
              InkWell(
                onTap: controller.pickFromGallery,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              // Capture Button (Middle)
              InkWell(
                onTap: controller.takePicture,
                borderRadius: BorderRadius.circular(44),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 4,
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // Manual Form Entry Button (Right)
              InkWell(
                onTap: controller.navigateToManualForm,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Icon(
                    Icons.edit_document,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditorView(BuildContext context, PhotoTransactionController controller) {
    return Column(
      children: [
        // Header title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 40),
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
            ],
          ),
        ),

        // Immersive Centered Photo
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
                  // Image file
                  Obx(() => Image.file(
                    File(controller.selectedImage.value!.path),
                    fit: BoxFit.cover,
                  )),

                  // Amount Sticker (Big central overlay)
                  Center(
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
                                if (controller.amount.value <= 0)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Chạm để nhập',
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
                  ),

                  // Left Pills Panel (Category, Wallet, Payer, Date)
                  Positioned(
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
                          if (!isPersonal) ...[
                            _buildGlassPill(
                              icon: Icons.person_outline,
                              text: 'Trả: $payerName',
                              onTap: controller.showPayerSelector,
                              isLocked: controller.isSelectedWalletPersonal,
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
                  ),

                  // Note bubble sticker (Right bottom)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.showNoteSheet,
                        borderRadius: BorderRadius.circular(20),
                        child: Obx(() {
                          final displayNote = controller.note.value.isEmpty ? 'Thêm ghi chú...' : controller.note.value;
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
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Actions Bar (Hủy và Gửi)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button (X)
              InkWell(
                onTap: () {
                  if (image == null) {
                    controller.clearSelectedImage();
                  } else {
                    Get.back();
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),

              // Send Button (Paper plane)
              InkWell(
                onTap: controller.submit,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              // Empty placeholder for symmetry matching Aa/icon
              const SizedBox(width: 56),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Instantiate/Retrieve the controller
    final controller = Get.put(PhotoTransactionController(
      coupleController: coupleController,
      initialImage: image,
      isPersonal: isPersonal,
      ownerId: ownerId,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            final loadingText = controller.isUploadingBackground.value
                ? 'Đang hoàn tất tải ảnh lên...'
                : 'Đang lưu giao dịch...';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    loadingText,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (controller.selectedImage.value == null) {
            return _buildCameraView(context, controller);
          }

          return _buildEditorView(context, controller);
        }),
      ),
    );
  }
}
