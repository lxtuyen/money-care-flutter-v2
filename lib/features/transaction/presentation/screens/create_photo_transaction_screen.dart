import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/photo_transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';

class CreatePhotoTransactionScreen extends StatefulWidget {
  const CreatePhotoTransactionScreen({super.key});

  @override
  State<CreatePhotoTransactionScreen> createState() =>
      _CreatePhotoTransactionScreenState();
}

class _CreatePhotoTransactionScreenState
    extends State<CreatePhotoTransactionScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final PhotoTransactionController controller;

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isTakingPhoto = false;

  bool _showForm = false;

  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<PhotoTransactionController>();
    controller.reset();
    _initCamera();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      await _startCamera(_selectedCameraIndex);
    } catch (_) {}
  }

  Future<void> _startCamera(int index) async {
    final prev = _cameraController;
    if (prev != null) {
      _isCameraInitialized = false;
      await prev.dispose();
      _cameraController = null;
    }
    final cam = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );
    _cameraController = cam;
    try {
      await cam.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (_) {
      if (mounted) setState(() => _isCameraInitialized = false);
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;
    setState(() => _isCameraInitialized = false);
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _startCamera(_selectedCameraIndex);
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_isCameraInitialized) return;
    _isFlashOn = !_isFlashOn;
    await _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {});
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_isCameraInitialized || _isTakingPhoto) {
      return;
    }
    setState(() => _isTakingPhoto = true);
    try {
      final file = await _cameraController!.takePicture();

      // Hiển thị loading khi đang xử lý ảnh
      setState(() => _isTakingPhoto = true);

      final croppedPath = await _cropImage(file.path);
      controller.selectedImagePath.value = croppedPath;
      setState(() => _showForm = true);
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể chụp ảnh: $e');
    } finally {
      if (mounted) setState(() => _isTakingPhoto = false);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      // Đối với ảnh từ gallery, có thể chúng ta không cần crop tự động
      // vì người dùng đã tự chọn ảnh ưng ý, nhưng nếu muốn đồng bộ có thể thêm ở đây.
      controller.selectedImagePath.value = image.path;
      setState(() => _showForm = true);
    }
  }

  Future<String> _cropImage(String path) async {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final bytes = await File(path).readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return path;

    // Fix orientation if needed
    image = img.bakeOrientation(image);

    final int width = image.width;
    final int height = image.height;

    // 1. Xác định tỉ lệ của Preview Area trên màn hình
    // Top 60, Bottom 180 => Preview height = ScreenHeight - 240
    // Preview width = ScreenWidth
    final double previewHeight = screenHeight - 240;
    final double previewWidth = screenWidth;
    final double previewAspectRatio = previewWidth / previewHeight;

    // 2. Xác định tỉ lệ ảnh gốc
    final double imageAspectRatio = width / height;

    double scale;
    double offsetX = 0;
    double offsetY = 0;

    // Tính toán xem camera preview đang được "cover" như thế nào
    if (imageAspectRatio > previewAspectRatio) {
      // Ảnh rộng hơn màn hình -> Bị cắt hai bên
      scale = previewHeight / height;
      offsetX = (width - previewWidth / scale) / 2;
    } else {
      // Ảnh dài hơn màn hình -> Bị cắt trên dưới
      scale = previewWidth / width;
      offsetY = (height - previewHeight / scale) / 2;
    }

    // 3. Tính toán vùng crop (85% width, 60% height của vùng nhìn thấy)
    final int cropWidth = (previewWidth * 0.85 / scale).toInt();
    final int cropHeight = (previewHeight * 0.60 / scale).toInt();

    final int x = (offsetX + (previewWidth * 0.075 / scale))
        .toInt(); // 0.075 = (1 - 0.85) / 2
    final int y = (offsetY + (previewHeight * 0.20 / scale))
        .toInt(); // 0.20 = (1 - 0.60) / 2

    final croppedImage = img.copyCrop(
      image,
      x: x,
      y: y,
      width: cropWidth,
      height: cropHeight,
    );

    // Lưu đè lên file cũ hoặc tạo file mới
    final croppedBytes = img.encodeJpg(croppedImage, quality: 85);
    final croppedFile = File(path.replaceAll('.jpg', '_cropped.jpg'));
    await croppedFile.writeAsBytes(croppedBytes);

    return croppedFile.path;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _initCamera();
      return;
    }

    final cam = _cameraController;
    if (cam == null || !cam.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _isCameraInitialized = false;
      await cam.dispose();
      _cameraController = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showForm ? _buildFormView() : _buildCameraView();
  }

  Widget _buildCameraView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 180,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _isCameraInitialized && _cameraController != null
                    ? Stack(
                        children: [
                          CameraPreview(_cameraController!),
                          _ScannerOverlay(animation: _scanController),
                        ],
                      )
                    : Container(
                        color: Colors.black87,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                          ),
                        ),
                      ),
              ),
            ),
          ),

          Positioned(
            top: 76,
            left: 24,
            child: _FlashButton(isOn: _isFlashOn, onTap: _toggleFlash),
          ),

          Positioned(
            top: 60,
            right: 16,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Get.back();
                  } else {
                    Get.toNamed(RoutePath.main);
                  }
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _CameraBottomBar(
              isTakingPhoto: _isTakingPhoto,
              onGallery: _pickFromGallery,
              onCapture: _takePhoto,
              onFlip: _flipCamera,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView() {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => setState(() {
            _showForm = false;
            controller.selectedImagePath.value = null;
          }),
        ),
        title: const Text(
          AppTexts.photoTransactionTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: AppSizes.fontSizeLg,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Obx(() {
                final path = controller.selectedImagePath.value;
                return _PhotoPreviewCard(
                  controller: controller,
                  imagePath: path,
                  onRetake: () => setState(() {
                    _showForm = false;
                    controller.selectedImagePath.value = null;
                  }),
                );
              }),
              const SizedBox(height: 16),

              _SectionCard(
                title: AppTexts.classificationSection,
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _TypeChip(
                          label: AppTexts.transactionTypeExpense,
                          icon: Icons.arrow_upward_rounded,
                          activeColor: AppColors.secondaryOrange,
                          isSelected: controller.isExpense,
                          onTap: () => controller.setTransactionType('expense'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TypeChip(
                          label: AppTexts.transactionTypeIncome,
                          icon: Icons.arrow_downward_rounded,
                          activeColor: AppColors.success,
                          isSelected: !controller.isExpense,
                          onTap: () => controller.setTransactionType('income'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _SectionCard(
                title: AppTexts.transactionInfoSection,
                child: Column(
                  children: [
                    AppCurrencyFormField(
                      controller: controller.amountController,
                      label: 'Số tiền', // TODO: Add to AppTexts
                      icon: Icons.payments_outlined,
                      hintText: 'Nhập số tiền',
                      validator: AppValidator.validateAmount,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => controller.isExpense
                          ? AppTextFormField(
                              controller: controller.categoryController,
                              label: 'Category',
                              icon: Icons.category_outlined,
                              hintText: AppTexts.selectCategory,
                              validator: AppValidator.validateCategory,
                              readOnly: true,
                              onTap: () => _showCategorySheet(context),
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.borderSecondary,
                                ),
                              ),
                              child: const Text(
                                AppTexts.incomeNoCategoryMessage,
                                style: TextStyle(
                                  color: AppColors.text3,
                                  fontSize: AppSizes.fontSizeSm,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    DatePickerField(
                      selectedDate: controller.selectedDate,
                      label: 'Ngày giao dịch',
                      placeholder: 'Chọn ngày giao dịch',
                      onTap: () => controller.selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      controller: controller.noteController,
                      label: 'Ghi chú',
                      hintText: 'Nhập ghi chú cho bản ghi',
                      validator: AppValidator.validateNote,
                      minLines: 4,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Obx(
            () => PrimaryButton(
              label: 'Lưu bản ghi', // TODO: Add to AppTexts
              onPressed: controller.submit,
              isLoading: controller.transactionController.isLoading.value,
              isEnabled: !controller.transactionController.isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCategorySheet(BuildContext context) async {
    final selected = await showModalBottomSheet<CategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Obx(() {
          if (controller.savingGoalController.isLoadingCurrent.value) {
            return const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final currentGoal = controller.savingGoalController.currentGoal.value;
          if (currentGoal == null) {
            return const SizedBox(
              height: 220,
              child: Center(child: Text(AppTexts.noCategoryAvailable)),
            );
          }
          final categories = currentGoal.categories;
          return CategorySheet(
            categories: categories,
            selectedCategoryInit: controller.selectedCategoryId.value != null
                ? categories.firstWhereOrNull(
                    (c) => c.id == controller.selectedCategoryId.value,
                  )
                : null,
          );
        });
      },
    );
    if (selected != null) {
      controller.setCategory(selected);
    }
  }
}

// ─── Camera Bottom Bar ────────────────────────────────────────────────────────

class _CameraBottomBar extends StatelessWidget {
  const _CameraBottomBar({
    required this.isTakingPhoto,
    required this.onGallery,
    required this.onCapture,
    required this.onFlip,
  });

  final bool isTakingPhoto;
  final VoidCallback onGallery;
  final VoidCallback onCapture;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(40, 24, 40, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onGallery,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              GestureDetector(
                onTap: isTakingPhoto ? null : onCapture,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE8A020),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: isTakingPhoto
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onFlip,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.flip_camera_ios_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FlashButton extends StatelessWidget {
  const _FlashButton({required this.isOn, required this.onTap});

  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isOn ? Colors.amber : Colors.black45,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _PhotoPreviewCard extends StatelessWidget {
  const _PhotoPreviewCard({
    required this.controller,
    required this.imagePath,
    required this.onRetake,
  });

  final PhotoTransactionController controller;

  final String? imagePath;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppTexts.photoPreviewTitle,
                  style: TextStyle(
                    color: AppColors.text1,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton.icon(
                  onPressed: controller.isScanning.value
                      ? null
                      : controller.scanWithAI,
                  icon: controller.isScanning.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.secondaryNavyBlue,
                          ),
                        )
                      : const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: Text(
                    controller.isScanning.value
                        ? AppTexts.scanningStatus
                        : AppTexts.scanAiButton,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryNavyBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (imagePath != null)
            GestureDetector(
              onTap: () => _showFullScreenImage(context, imagePath!),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                child: imagePath!.startsWith('http')
                    ? Image.network(
                        imagePath!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imagePath!),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String path) {
    Get.dialog(
      Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: path.startsWith('http')
                    ? Image.network(path)
                    : Image.file(File(path)),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text1,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.activeColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.borderSecondary,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? activeColor : AppColors.text4),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : AppColors.text3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Scanner Overlay ──────────────────────────────────────────────────────────

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double parentWidth = constraints.maxWidth;
        final double parentHeight = constraints.maxHeight;

        final double holeWidth = parentWidth * 0.85;
        final double holeHeight = parentHeight * 0.60;

        return Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.5),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: holeHeight,
                      width: holeWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Corners and Scan Line
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: holeHeight,
                width: holeWidth,
                child: Stack(
                  children: [
                    // Stylized Corners
                    CustomPaint(
                      painter: _ScannerPainter(),
                      size: Size.infinite,
                    ),

                    // Moving Scan Line
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Positioned(
                          top: animation.value * holeHeight,
                          left: 0,
                          right: 0,
                          child: child!,
                        );
                      },
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.01),
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.01),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Instructions
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.document_scanner_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Căn chỉnh hóa đơn vào khung',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const cornerSize = 30.0;
    const radius = 20.0;

    // Top Left
    final path1 = Path()
      ..moveTo(0, cornerSize)
      ..lineTo(0, radius)
      ..arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      )
      ..lineTo(cornerSize, 0);
    canvas.drawPath(path1, paint);

    // Top Right
    final path2 = Path()
      ..moveTo(size.width - cornerSize, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width, cornerSize);
    canvas.drawPath(path2, paint);

    // Bottom Left
    final path3 = Path()
      ..moveTo(0, size.height - cornerSize)
      ..lineTo(0, size.height - radius)
      ..arcToPoint(
        Offset(radius, size.height),
        radius: const Radius.circular(radius),
      )
      ..lineTo(cornerSize, size.height);
    canvas.drawPath(path3, paint);

    // Bottom Right
    final path4 = Path()
      ..moveTo(size.width - cornerSize, size.height)
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(
        Offset(size.width, size.height - radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width, size.height - cornerSize);
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
