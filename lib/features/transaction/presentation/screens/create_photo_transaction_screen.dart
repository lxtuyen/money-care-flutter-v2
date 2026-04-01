import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/photo_transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/screens/photo_transaction_history_screen.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';

class CreatePhotoTransactionScreen extends StatefulWidget {
  const CreatePhotoTransactionScreen({super.key});

  @override
  State<CreatePhotoTransactionScreen> createState() =>
      _CreatePhotoTransactionScreenState();
}

class _CreatePhotoTransactionScreenState
    extends State<CreatePhotoTransactionScreen> with WidgetsBindingObserver {
  late final PhotoTransactionController controller;

  // Camera
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isTakingPhoto = false;

  // View mode: camera or form
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<PhotoTransactionController>();
    controller.reset();
    _initCamera();
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
      await prev.dispose();
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
    if (_cameraController == null ||
        !_isCameraInitialized ||
        _isTakingPhoto) {
      return;
    }
    setState(() => _isTakingPhoto = true);
    try {
      final file = await _cameraController!.takePicture();
      controller.selectedImagePath.value = file.path;
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
      controller.selectedImagePath.value = image.path;
      setState(() => _showForm = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cam = _cameraController;
    if (cam == null || !cam.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      cam.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _startCamera(_selectedCameraIndex);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showForm ? _buildFormView() : _buildCameraView();
  }

  // ─── Camera View ────────────────────────────────────────────────────────────

  Widget _buildCameraView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          Positioned.fill(
            bottom: 180,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _isCameraInitialized && _cameraController != null
                    ? CameraPreview(_cameraController!)
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

          // Flash button on preview
          Positioned(
            top: 76,
            left: 24,
            child: _FlashButton(
              isOn: _isFlashOn,
              onTap: _toggleFlash,
            ),
          ),

          // Back button
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
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _CameraBottomBar(
              isTakingPhoto: _isTakingPhoto,
              onGallery: _pickFromGallery,
              onCapture: _takePhoto,
              onFlip: _flipCamera,
              onHistory:
                  () => Get.to(() => const PhotoTransactionHistoryScreen()),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Form View ──────────────────────────────────────────────────────────────

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
          'Bản ghi kèm ảnh',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Photo preview
              Obx(() {
                final path = controller.selectedImagePath.value;
                return _PhotoPreviewCard(
                  imagePath: path,
                  onRetake: () => setState(() {
                    _showForm = false;
                    controller.selectedImagePath.value = null;
                  }),
                );
              }),
              const SizedBox(height: 16),

              // Type
              _SectionCard(
                title: 'Phân loại',
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _TypeChip(
                          label: 'Chi',
                          icon: Icons.arrow_upward_rounded,
                          activeColor: AppColors.secondaryOrange,
                          isSelected: controller.isExpense,
                          onTap: () => controller.setTransactionType('expense'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TypeChip(
                          label: 'Thu',
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

              // Info
              _SectionCard(
                title: 'Thông tin bản ghi',
                child: Column(
                  children: [
                    AppCurrencyFormField(
                      controller: controller.amountController,
                      label: 'Số tiền',
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
                              hintText: 'Chọn category',
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
                                'Bản ghi thu hiện không yêu cầu category.',
                                style: TextStyle(
                                  color: AppColors.text3,
                                  fontSize: 14,
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
            color: Colors.white,
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
              label: 'Lưu bản ghi',
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
          if (controller.savingFundController.isLoadingCurrent.value) {
            return const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final currentFund =
              controller.savingFundController.currentFund.value;
          if (currentFund == null) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: Text('Không có category để lựa chọn'),
              ),
            );
          }
          final categories = currentFund.categories;
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
    required this.onHistory,
  });

  final bool isTakingPhoto;
  final VoidCallback onGallery;
  final VoidCallback onCapture;
  final VoidCallback onFlip;
  final VoidCallback onHistory;

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
              // Gallery
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

              // Capture button
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

              // Flip camera
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onHistory,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Lịch sử',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Flash Button ─────────────────────────────────────────────────────────────

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

// ─── Photo Preview Card ───────────────────────────────────────────────────────

class _PhotoPreviewCard extends StatelessWidget {
  const _PhotoPreviewCard({
    required this.imagePath,
    required this.onRetake,
  });

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
                  'Ảnh giao dịch',
                  style: TextStyle(
                    color: AppColors.text1,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton.icon(
                  onPressed: onRetake,
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text('Chụp lại'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryNavyBlue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          if (imagePath != null)
            ClipRRect(
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
        ],
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

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

// ─── Type Chip ────────────────────────────────────────────────────────────────

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
