import 'package:flutter/material.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_form.dart';

class CreateIncomeScreen extends StatefulWidget {
  const CreateIncomeScreen({super.key});

  @override
  State<CreateIncomeScreen> createState() => _CreateIncomeScreenState();
}

class _CreateIncomeScreenState extends State<CreateIncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      title: "Tiền Thu",
      showCategory: false,
    );
  }
}
