import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/payment/data/models/payment_request_dto.dart';
import 'package:money_care/features/payment/presentation/controllers/payment_controller.dart';
import 'package:money_care/features/payment/presentation/screens/payment_configs.dart';
import 'package:pay/pay.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final paymentController = Get.find<PaymentController>();

  bool _isPlanUnlocked = false;
  int? _userId;

  List<PaymentItem> get _items => const [
        PaymentItem(
          label: 'Mo khoa tinh nang VIP',
          amount: '50000',
          status: PaymentItemStatus.final_price,
        ),
      ];

  @override
  void initState() {
    super.initState();
    final userInfoJson = LocalStorage().getUserInfo();
    if (userInfoJson != null) {
      _userId = UserModel.fromJson(userInfoJson, '').id;
    }
  }

  Future<void> _handleResult({
    required String platform,
    required Map<String, dynamic> result,
  }) async {
    if (_userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Khong the xac dinh nguoi dung hien tai')),
      );
      return;
    }

    final dto = PaymentRequestDto(
      platform: platform,
      amount: 50000.0,
      currency: 'VND',
      userId: _userId!,
    );

    final success = await paymentController.confirm(dto);

    if (!mounted) return;

    if (success) {
      setState(() => _isPlanUnlocked = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toan thanh cong! Premium da duoc mo khoa.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toan that bai')),
      );
    }
  }

  Widget _buildGooglePay() {
    return GooglePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: _items,
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15),
      onPaymentResult: (result) async {
        await _handleResult(
          platform: 'google_pay',
          result: Map<String, dynamic>.from(result as Map),
        );
      },
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildApplePay() {
    return ApplePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultApplePay),
      paymentItems: _items,
      type: ApplePayButtonType.buy,
      style: ApplePayButtonStyle.black,
      width: 250,
      height: 50,
      margin: const EdgeInsets.only(top: 15),
      onPaymentResult: (result) async {
        await _handleResult(
          platform: 'apple_pay',
          result: Map<String, dynamic>.from(result as Map),
        );
      },
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = !kIsWeb && Platform.isIOS;
    final isAndroid = !kIsWeb && Platform.isAndroid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mo khoa Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => paymentController.isLoading.value
                ? const LinearProgressIndicator()
                : const SizedBox()),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isPlanUnlocked ? Icons.verified : Icons.lock,
                    color: _isPlanUnlocked ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isPlanUnlocked
                          ? 'Premium da duoc mo khoa'
                          : 'Premium dang bi khoa - thanh toan de mo',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_isPlanUnlocked) ...[
              if (isAndroid) _buildGooglePay(),
              if (isIOS) _buildApplePay(),
              if (!isAndroid && !isIOS)
                const Text('Thiet bi khong ho tro GooglePay/ApplePay'),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

