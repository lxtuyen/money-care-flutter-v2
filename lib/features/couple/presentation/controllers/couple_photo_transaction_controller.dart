import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

class CouplePhotoTransactionController extends GetxController {
  final CoupleController coupleController;
  final XFile? initialImage;

  CouplePhotoTransactionController({
    required this.coupleController,
    this.initialImage,
  });

  // State Variables
  final RxDouble amount = 0.0.obs;
  final RxString note = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rxn<CategoryEntity> selectedCategory = Rxn<CategoryEntity>();
  final Rxn<WalletEntity> selectedWallet = Rxn<WalletEntity>();
  final RxnInt selectedPayerId = RxnInt();
  final RxBool isLoading = false.obs;

  bool get isSelectedWalletPersonal {
    if (selectedWallet.value == null) return false;
    return !coupleController.sharedWallets
        .any((w) => w.id == selectedWallet.value!.id);
  }

  // Background Upload States
  final RxnString uploadedPictureUrl = RxnString();
  final RxBool isUploadingBackground = false.obs;
  final RxnString uploadError = RxnString();
  Future<String?>? _preUploadFuture;

  // Camera States
  final Rxn<XFile> selectedImage = Rxn<XFile>();
  CameraController? cameraController;
  List<CameraDescription> _cameras = [];
  final RxBool isCameraInitialized = false.obs;
  final Rx<FlashMode> flashMode = FlashMode.off.obs;
  final RxBool isPermissionDenied = false.obs;
  final int _selectedCameraIndex = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaults();

    // Listen to image changes to trigger pre-upload
    ever(selectedImage, (image) {
      if (image == null) {
        uploadedPictureUrl.value = null;
        isUploadingBackground.value = false;
        uploadError.value = null;
        _preUploadFuture = null;
      } else {
        uploadedPictureUrl.value = null;
        uploadError.value = null;
        isUploadingBackground.value = true;
        _preUploadFuture = _performBackgroundUpload(image);
      }
    });

    if (initialImage != null) {
      selectedImage.value = initialImage;
    } else {
      initCamera();
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  void _initializeDefaults() {
    final categoryController = Get.find<UserCategoryController>();
    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id;

    // Load categories if they are empty and userId is available
    if (categoryController.categories.isEmpty && currentUserId != null) {
      categoryController.loadCategories(currentUserId);
    }

    // Listen to changes to set the default selectedCategory once categories load
    ever(categoryController.categories, (cats) {
      if (selectedCategory.value == null && cats.isNotEmpty) {
        final expenseCats = cats.where((c) => c.type == 'expense').toList();
        if (expenseCats.isNotEmpty) {
          selectedCategory.value = expenseCats.first;
        }
      }
    });

    final expenseCats = categoryController.categories
        .where((c) => c.type == 'expense')
        .toList();
    if (expenseCats.isNotEmpty) {
      selectedCategory.value = expenseCats.first;
    }

    final savingWalletIds = coupleController.savingGoals
        .map((g) => g.walletId)
        .whereType<int>()
        .toSet();
    final nonSavingWallets = coupleController.sharedWallets
        .where((w) => w.savingGoals.isEmpty && !savingWalletIds.contains(w.id))
        .toList();
    if (nonSavingWallets.isNotEmpty) {
      selectedWallet.value = nonSavingWallets.first;
    } else {
      if (Get.isRegistered<WalletController>()) {
        final walletController = Get.find<WalletController>();
        final nonSavingPersonal = walletController.wallets
            .where((w) => w.savingGoals.isEmpty)
            .toList();
        if (nonSavingPersonal.isNotEmpty) {
          selectedWallet.value = nonSavingPersonal.first;
        }
      }
    }

    if (currentUserId != null) {
      selectedPayerId.value = currentUserId;
    } else if (coupleController.couple.value?.members.isNotEmpty == true) {
      selectedPayerId.value = coupleController.couple.value!.members.first.userId;
    }
  }

  Future<void> initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _onNewCameraSelected(_cameras[_selectedCameraIndex]);
      } else {
        isPermissionDenied.value = true;
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      isPermissionDenied.value = true;
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }

    final CameraController controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    cameraController = controller;

    try {
      await controller.initialize();
      await controller.setFlashMode(flashMode.value);
      isCameraInitialized.value = true;
      isPermissionDenied.value = false;
    } on CameraException catch (e) {
      debugPrint('Error initializing camera controller: $e');
      if (e.code == 'CameraAccessDenied') {
        isPermissionDenied.value = true;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> toggleFlash() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;

    FlashMode nextFlash;
    switch (flashMode.value) {
      case FlashMode.off:
        nextFlash = FlashMode.always;
        break;
      case FlashMode.always:
        nextFlash = FlashMode.auto;
        break;
      case FlashMode.auto:
        nextFlash = FlashMode.torch;
        break;
      case FlashMode.torch:
        nextFlash = FlashMode.off;
        break;
    }

    try {
      await cameraController!.setFlashMode(nextFlash);
      flashMode.value = nextFlash;
    } catch (e) {
      debugPrint('Error setting flash mode: $e');
    }
  }

  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;
    if (cameraController!.value.isTakingPicture) return;

    try {
      final XFile rawImage = await cameraController!.takePicture();
      selectedImage.value = rawImage;
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      selectedImage.value = pickedFile;
    }
  }

  void navigateToManualForm() {
    Get.offAndToNamed(
      RoutePath.createTransaction,
      arguments: {
        'type': 'expense',
        'isShared': true,
      },
    );
  }

  void clearSelectedImage() {
    selectedImage.value = null;
    initCamera();
  }

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).primaryColor,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate.value),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: Theme.of(context).primaryColor,
                surface: const Color(0xFF1E1E1E),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        selectedDate.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      } else {
        selectedDate.value = picked;
      }
    }
  }

  Future<String?> _performBackgroundUpload(XFile image) async {
    try {
      if (selectedImage.value != image) return null;

      XFile fileToUpload = image;
      try {
        fileToUpload = await compressImage(fileToUpload);
      } catch (e) {
        debugPrint('Image compression failed, using original: $e');
      }

      if (selectedImage.value != image) return null;

      final apiClient = Get.find<ApiClient>();
      final uploadRes = await apiClient.postMultipart<Map<String, dynamic>>(
        'couples/upload',
        file: fileToUpload,
        fromJsonT: (json) => Map<String, dynamic>.from(json),
      );

      // Clean up the temporary compressed file if it was created
      if (fileToUpload.path != image.path) {
        try {
          final tempFile = File(fileToUpload.path);
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } catch (e) {
          debugPrint('Error deleting temporary compressed file: $e');
        }
      }

      if (selectedImage.value != image) return null;

      if (!uploadRes.success || uploadRes.data == null) {
        final errorMsg = uploadRes.message.isNotEmpty ? uploadRes.message : 'Tải ảnh lên thất bại';
        uploadError.value = errorMsg;
        isUploadingBackground.value = false;
        return null;
      }

      final pictureUrl = uploadRes.data!['url'] as String;
      uploadedPictureUrl.value = pictureUrl;
      isUploadingBackground.value = false;
      return pictureUrl;
    } catch (e) {
      debugPrint('Background upload failed: $e');
      if (selectedImage.value == image) {
        uploadError.value = e.toString();
        isUploadingBackground.value = false;
      }
      return null;
    }
  }

  Future<void> submit() async {
    final amtValue = amount.value;
    if (amtValue <= 0) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chạm vào tâm ảnh để nhập số tiền');
      return;
    }
    if (selectedCategory.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn danh mục');
      return;
    }
    if (selectedWallet.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn ví chung');
      return;
    }
    if (selectedPayerId.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn người thanh toán');
      return;
    }
    if (selectedImage.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn hoặc chụp ảnh giao dịch');
      return;
    }

    isLoading.value = true;
    try {
      String? pictureUrl = uploadedPictureUrl.value;

      if (pictureUrl == null) {
        if (uploadError.value != null) {
          AppHelperFunction.showSuccessSnackBar('Đang tải lại ảnh lên...');
          final image = selectedImage.value;
          if (image != null) {
            _preUploadFuture = _performBackgroundUpload(image);
          }
        }

        if (_preUploadFuture != null) {
          pictureUrl = await _preUploadFuture;
        }
      }

      if (pictureUrl == null) {
        throw Exception(uploadError.value ?? 'Tải ảnh lên thất bại. Vui lòng thử lại.');
      }

      // 2. Save Shared Transaction (defaults to 'none' if paid from a shared wallet, 'equal' otherwise)
      final isSharedWallet = coupleController.sharedWallets
          .any((w) => w.id == selectedWallet.value?.id);
      final splitMethod = isSharedWallet ? 'none' : 'equal';

      await coupleController.addSharedTransaction(
        amount: amtValue.toInt(),
        type: 'expense',
        note: note.value,
        walletId: selectedWallet.value!.id,
        categoryId: selectedCategory.value!.id!,
        payerId: selectedPayerId.value!,
        date: selectedDate.value,
        splitMethod: splitMethod,
        pictureUrl: pictureUrl,
      );

      Get.back();
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showAmountSheet() {
    final colors = AppThemeColors.of(Get.context!);
    final controller = TextEditingController(
      text: amount.value > 0
          ? AppHelperFunction.formatCurrency(amount.value.toInt().toString())
          : '',
    );
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nhập số tiền',
              style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _AmountInputFormatter(),
              ],
              decoration: InputDecoration(
                hintText: '0đ',
                hintStyle: TextStyle(color: colors.textHint),
                suffixText: 'VND',
                suffixStyle: TextStyle(color: colors.textSecondary, fontSize: 16),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.borderSecondary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(Get.context!).primaryColor)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final raw = AppHelperFunction.unformatCurrency(controller.text.trim());
                final amt = double.tryParse(raw) ?? 0.0;
                amount.value = amt;
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void showNoteSheet() {
    final colors = AppThemeColors.of(Get.context!);
    final controller = TextEditingController(text: note.value);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thêm ghi chú',
              style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              style: TextStyle(color: colors.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Nhập nội dung ghi chú...',
                hintStyle: TextStyle(color: colors.textHint),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.borderSecondary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(Get.context!).primaryColor)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                note.value = controller.text.trim();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void showCategorySelector() {
    final colors = AppThemeColors.of(Get.context!);
    final categoryController = Get.find<UserCategoryController>();

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.6),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn danh mục',
              style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final expenseCats = categoryController.categories
                    .where((c) => c.type == 'expense')
                    .toList();

                if (expenseCats.isEmpty) {
                  return Center(
                    child: Text(
                      'Không có danh mục nào',
                      style: TextStyle(color: colors.textSecondary, fontSize: 14),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: expenseCats.length,
                  itemBuilder: (context, index) {
                    final cat = expenseCats[index];
                    final isSelected = selectedCategory.value?.id == cat.id;
                    return InkWell(
                      onTap: () {
                        selectedCategory.value = cat;
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                              : colors.surfaceBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : colors.borderSecondary,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 8),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colors.textPrimary, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showWalletSelector() {
    final colors = AppThemeColors.of(Get.context!);
    final savingWalletIds = coupleController.savingGoals
        .map((g) => g.walletId)
        .whereType<int>()
        .toSet();
    final nonSavingSharedWallets = coupleController.sharedWallets
        .where((w) => w.savingGoals.isEmpty && !savingWalletIds.contains(w.id))
        .toList();

    List<WalletEntity> nonSavingPersonalWallets = [];
    if (Get.isRegistered<WalletController>()) {
      nonSavingPersonalWallets = Get.find<WalletController>().wallets
          .where((w) => w.savingGoals.isEmpty)
          .toList();
    }

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.65),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn ví liên kết',
              style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  // --- Ví chung section ---
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'VÍ CHUNG CHIA SẺ',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  if (nonSavingSharedWallets.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Không có ví chi tiêu chung hợp lệ',
                        style: TextStyle(color: colors.textHint, fontSize: 13),
                      ),
                    )
                  else
                    ...nonSavingSharedWallets.map((w) {
                      final isSelected = selectedWallet.value?.id == w.id && !isSelectedWalletPersonal;
                      return ListTile(
                        onTap: () {
                          selectedWallet.value = w;
                          Get.back();
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.group_outlined,
                          color: isSelected ? Theme.of(Get.context!).primaryColor : colors.textSecondary,
                        ),
                        title: Text(w.name, style: TextStyle(color: colors.textPrimary)),
                        subtitle: Text(
                          AppHelperFunction.formatAmount(w.balance),
                          style: TextStyle(color: colors.textSecondary, fontSize: 12),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: Theme.of(Get.context!).primaryColor)
                            : null,
                      );
                    }),
                  
                  const Divider(height: 24),

                  // --- Ví cá nhân section ---
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'VÍ CÁ NHÂN CỦA BẠN',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  if (nonSavingPersonalWallets.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Không có ví cá nhân hợp lệ',
                        style: TextStyle(color: colors.textHint, fontSize: 13),
                      ),
                    )
                  else
                    ...nonSavingPersonalWallets.map((w) {
                      final isSelected = selectedWallet.value?.id == w.id && isSelectedWalletPersonal;
                      return ListTile(
                        onTap: () {
                          selectedWallet.value = w;
                          // Auto set payer to current user when selecting personal wallet
                          final authController = Get.find<AuthController>();
                          final currentUserId = authController.user.value?.id;
                          if (currentUserId != null) {
                            selectedPayerId.value = currentUserId;
                          }
                          Get.back();
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.person_outline,
                          color: isSelected ? Theme.of(Get.context!).primaryColor : colors.textSecondary,
                        ),
                        title: Text(w.name, style: TextStyle(color: colors.textPrimary)),
                        subtitle: Text(
                          AppHelperFunction.formatAmount(w.balance),
                          style: TextStyle(color: colors.textSecondary, fontSize: 12),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: Theme.of(Get.context!).primaryColor)
                            : null,
                      );
                    }),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPayerSelector() {
    if (isSelectedWalletPersonal) {
      AppHelperFunction.showWarningSnackBar('Giao dịch dùng ví cá nhân nên bạn là người thanh toán.');
      return;
    }

    final colors = AppThemeColors.of(Get.context!);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn người thanh toán',
              style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...(coupleController.couple.value?.members ?? []).map((m) {
              final isSelected = selectedPayerId.value == m.userId;
              return ListTile(
                onTap: () {
                  selectedPayerId.value = m.userId;
                  Get.back();
                },
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? Theme.of(Get.context!).primaryColor
                      : colors.surfaceBackground,
                  radius: 18,
                  child: Text(
                    m.initials,
                    style: TextStyle(
                      color: isSelected ? Colors.white : colors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(m.fullName, style: TextStyle(color: colors.textPrimary)),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Theme.of(Get.context!).primaryColor)
                    : null,
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<XFile> compressImage(XFile original) async {
    try {
      final compressedPath = await compute(_compressImageIsolate, original.path);
      return XFile(compressedPath);
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return original;
    }
  }
}

class _AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawValue = AppHelperFunction.unformatCurrency(newValue.text);
    final formattedValue = AppHelperFunction.formatCurrency(rawValue);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
      composing: TextRange.empty,
    );
  }
}

// Helper function to compress image in a separate isolate
Future<String> _compressImageIsolate(String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();

  final image = img.decodeImage(bytes);
  if (image == null) return path;

  // Resize if it's too large (e.g. width/height > 1024)
  img.Image resized = image;
  const maxDimension = 1024;
  if (image.width > maxDimension || image.height > maxDimension) {
    if (image.width > image.height) {
      resized = img.copyResize(image, width: maxDimension);
    } else {
      resized = img.copyResize(image, height: maxDimension);
    }
  }

  // Compress to JPEG with quality 75
  final compressedBytes = img.encodeJpg(resized, quality: 75);

  // Write to temporary file
  final tempDir = Directory.systemTemp;
  final tempFile = File('${tempDir.path}/compressed_${DateTime.now().microsecondsSinceEpoch}.jpg');
  await tempFile.writeAsBytes(compressedBytes);
  return tempFile.path;
}
