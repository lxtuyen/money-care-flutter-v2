import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/recommendation/presentation/utils/place_query_utils.dart';
import 'package:money_care/features/recommendation/presentation/widgets/place_checkin_sheet.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class CheckinPromptService extends GetxService {
  CheckinPromptService({required LocalStorage storage}) : _storage = storage;

  final LocalStorage _storage;
  final RxBool promptEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    promptEnabled.value = _storage.getCheckinPromptEnabled();
  }

  Future<void> setPromptEnabled(bool value) async {
    promptEnabled.value = value;
    await _storage.saveCheckinPromptEnabled(value);
  }

  Future<void> promptForExpense(TransactionEntity transaction) async {
    if (transaction.type != 'expense' || transaction.id == null) return;
    if (!promptEnabled.value) return;
    if (!shouldAutoPromptCheckinForCategory(transaction.category?.name)) return;

    var dontAskAgain = false;
    final shouldCheckin = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Check-in dia diem?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ban co muon luu dia diem cho khoan chi nay khong?'),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: dontAskAgain,
                  onChanged: (value) {
                    setState(() => dontAskAgain = value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Khong hoi lai'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Bo qua'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Get.back(result: true),
                child: const Text('Check-in'),
              ),
            ],
          );
        },
      ),
      barrierDismissible: true,
    );

    if (dontAskAgain) {
      await setPromptEnabled(false);
    }

    if (shouldCheckin == true) {
      await PlaceCheckinSheet.show(
        transactionId: transaction.id!,
        initialQuery: queryFromCategory(transaction.category?.name),
      );
    }
  }
}
