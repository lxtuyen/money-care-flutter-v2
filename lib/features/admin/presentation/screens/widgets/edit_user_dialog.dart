import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/admin/domain/entities/entities.dart';
import 'package:money_care/features/admin/presentation/controllers/admin_controller.dart';
import 'package:money_care/features/user/data/models/user_profile_model.dart';

class EditUserDialog extends StatefulWidget {
  final UserResponseEntity user;

  const EditUserDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late bool isVip;
  late String role;

  @override
  void initState() {
    super.initState();
    isVip = widget.user.isVip;
    role = widget.user.role;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chinh Sua Nguoi Dung',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Tai khoan VIP'),
              value: isVip,
              onChanged: (value) {
                setState(() => isVip = value);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'user', child: Text('User')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => role = value);
              },
              decoration: const InputDecoration(labelText: 'Vai tro'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: Get.back, child: const Text('Huy')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _onSave, child: const Text('Luu')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    final dto = UserUpdateDto(role: role, isVip: isVip);
    await Get.find<AdminController>().updateUser(widget.user.id, dto);
    Get.back();
  }
}
