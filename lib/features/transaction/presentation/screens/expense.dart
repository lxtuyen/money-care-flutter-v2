import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction/transaction_form.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null);
  }

  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      title: "Tiền Chi",
      showCategory: true,
    );
  }
}
