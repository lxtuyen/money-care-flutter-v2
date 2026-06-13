import 'package:get/get.dart';
import 'package:money_care/features/couple/presentation/bindings/couple_binding.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_form_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    CoupleBinding().dependencies();
    Get.lazyPut(() => FilterController(), fenix: true);
    Get.lazyPut(() => TransactionFormController(), fenix: true);
  }
}
