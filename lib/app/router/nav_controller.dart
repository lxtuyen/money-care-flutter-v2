import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;
  var isSidebarOpen = false.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void toggleSidebar() {
    isSidebarOpen.toggle();
  }
}
