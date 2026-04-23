import 'package:get/get.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';

class AppController extends GetxController {
  final LocalStorage storage;

  AppController({required this.storage});

  var userId = Rxn<int>();
  var isUserInitialized = false.obs;
  var errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    initializeUser();
  }

  Future<void> initializeUser() async {
    try {
      final userInfoJson = storage.getUserInfo();
      if (userInfoJson == null) {
        userId.value = null;
        isUserInitialized.value = true;
        return;
      }

      final user = UserModel.fromJson(userInfoJson);
      userId.value = user.id;
      isUserInitialized.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
      isUserInitialized.value = true;
    }
  }

  void setUserId(int? id) {
    userId.value = id;
    if (id != null) {
      isUserInitialized.value = true;
    }
  }

  void clearUser() {
    userId.value = null;
    isUserInitialized.value = false;
  }

  Future<int?> getCurrentUserId() async {
    if (!isUserInitialized.value) {
      await initializeUser();
    }
    return userId.value;
  }
}
