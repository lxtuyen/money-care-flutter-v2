import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/admin/presentation/controllers/admin_controller.dart';
import 'package:money_care/features/admin/presentation/screens/widgets/edit_user_dialog.dart';

class UsersContent extends StatefulWidget {
  const UsersContent({super.key});

  @override
  State<UsersContent> createState() => _UsersContentState();
}

class _UsersContentState extends State<UsersContent> {
  final AdminController adminController = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    adminController.fetchListUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quáº£n LÃ½ NgÆ°á»i DÃ¹ng',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _onAddUser,
                  icon: const Icon(Icons.add),
                  label: const Text('ThÃªm NgÆ°á»i DÃ¹ng'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Obx(() {
              if (adminController.isLoadingUser.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (adminController.listUsers.isEmpty) {
                return const Center(child: Text('KhÃ´ng cÃ³ ngÆ°á»i dÃ¹ng'));
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 8),
                  ],
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Loáº¡i TÃ i Khoáº£n')),
                    DataColumn(label: Text('Vai TrÃ²')),
                    DataColumn(label: Text('HÃ nh Äá»™ng')),
                  ],
                  rows:
                      adminController.listUsers
                          .map(
                            (user) => _buildUserRow(
                              user.id.toString(),
                              user.email,
                              user.isVip,
                              user.role,
                            ),
                          )
                          .toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _onAddUser() {}

  void _onEditUser(String id) {
    final user = adminController.listUsers.firstWhere(
      (u) => u.id.toString() == id,
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: EditUserDialog(user: user),
      ),
    );
  }

  DataRow _buildUserRow(String id, String email, bool isVip, String role) {
    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(email)),
        DataCell(_buildAccountType(isVip)),
        DataCell(_buildRole(role)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _onEditUser(id),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountType(bool isVip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isVip ? Colors.purple.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isVip ? 'VIP' : 'FREE',
        style: TextStyle(
          color: isVip ? Colors.purple : Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRole(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }
}
