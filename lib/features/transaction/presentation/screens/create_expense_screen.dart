import 'package:flutter/material.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_form.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      title: "Tiền Chi",
      showCategory: true,
    );
  }
}
