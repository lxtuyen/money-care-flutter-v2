import 'package:flutter/foundation.dart';
import 'package:money_care/features/transaction/data/models/transaction_totals_dto.dart';

void main() {
  final dto = TransactionTotalsDto(
    fundId: 1,
    startDate: '2026-04-15',
    endDate: '2026-04-15',
    type: 'expense'
  );
  
  debugPrint('DTO JSON: ${dto.toJson()}');
}
