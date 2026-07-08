import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../common/presentation/transactions/date_header.dart';
import '../../../../../../common/presentation/transactions/transaction_list.dart';

class SpendTrackerQueryResultsScreen extends StatelessWidget {
  const SpendTrackerQueryResultsScreen({super.key, required this.transactions});
  final Map<LocalDate, List<PastTransaction>> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query Results')),
      body: TransactionsList(
        transactions: transactions,
        headerBuilder: (d) => DateHeader(date: d),
      ),
    );
  }
}
