import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/core/presentation/widgets/icon/rounded_icon.dart';

class SelectSavingFundScreen extends StatefulWidget {
  const SelectSavingFundScreen({super.key});

  @override
  State<SelectSavingFundScreen> createState() => _SelectSavingFundScreenState();
}

class _SelectSavingFundScreenState extends State<SelectSavingFundScreen> {
  final SavingFundController controller = Get.find<SavingFundController>();
  final UserController userController = Get.find<UserController>();
  int selectedIndex = 0;
  late int userId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    Map<String, dynamic> userInfoJson = LocalStorage().getUserInfo()!;
    UserModel user = UserModel.fromJson(userInfoJson, '');
    await controller.loadFunds(user.id);
    setState(() {
      userId = user.id;
      selectedIndex = controller.savingFunds.indexWhere(
        (f) => f.id == controller.fundId.value,
      );
      if (selectedIndex == -1) selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Lựa chọn quỹ tiết kiệm?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingFunds.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.savingFunds.isEmpty) {
                      return const Center(
                        child: Text("Chưa có quỹ tiết kiệm nào"),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.savingFunds.length,
                      itemBuilder: (context, index) {
                        final fund = controller.savingFunds[index];

                        return GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    (selectedIndex == index)
                                        ? Colors.blue
                                        : Colors.grey.shade300,

                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  fund.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children:
                                      fund.categories.map((cat) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RoundedIcon(
                                              padding: const EdgeInsets.all(8),
                                              applyIconRadius: true,
                                              width: 40,
                                              height: 40,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              iconPath:
                                                  'assets/icons/${cat.icon}.svg',
                                              size: 24,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              cat.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '${cat.percentage}%',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/create_saving_fund');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF0F5),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Tự tạo quỹ tiết kiệm'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.savingFunds.isNotEmpty) {
                        final selectedFund =
                            controller.savingFunds[selectedIndex];

                        try {
                          await controller.selectSavingFund(
                            userId,
                            selectedFund.id,
                          );

                          if (userController.userProfile.value?.monthlyIncome ==
                              null) {
                            Get.toNamed('/onboarding_income');
                          } else {
                            Get.toNamed('/main');
                          }
                        } catch (e) {
                          Get.snackbar('Lỗi', 'Không thể lưu quỹ tiết kiệm');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Xác nhận",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
