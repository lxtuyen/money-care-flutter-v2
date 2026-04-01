import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class TransactionSearchAnchor extends StatefulWidget {
  const TransactionSearchAnchor({super.key, required this.listData});

  final List<TransactionEntity> listData;

  @override
  State<TransactionSearchAnchor> createState() =>
      _TransactionSearchAnchorState();
}

class _TransactionSearchAnchorState extends State<TransactionSearchAnchor> {
  final SearchController _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SearchAnchor.bar(
        barHintText: 'Nhập tên giao dịch',
        viewHintText: 'Tìm kiếm giao dịch',
        searchController: _searchController,
        suggestionsBuilder: (context, controller) {
          final query = controller.text.toLowerCase();

          final filtered = widget.listData.where((item) {
            return query.isEmpty ||
                (item.note?.toLowerCase().contains(query) ?? false);
          }).toList();

          if (filtered.isEmpty) {
            return [
              SizedBox(
                height: 100,
                child: Center(child: Text('Không tìm thấy giao dịch nào')),
              ),
            ];
          }

          final List<Widget> widgets = filtered.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TransactionItem(
                item: entry.value,
                onTap: () {},
                color: AppHelperFunction.getChartColorByIndex(entry.key),
              ),
            );
          }).toList();

          return [
            Material(
              color: Colors.white, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: widgets,
              ),
            ),
          ];
        },
      ),
    );
  }
}
