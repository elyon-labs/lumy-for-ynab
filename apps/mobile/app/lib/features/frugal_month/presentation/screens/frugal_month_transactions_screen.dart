import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../common/presentation/transactions/date_header.dart';
import '../../../../common/presentation/transactions/transaction_list.dart';

class FrugalMonthTransactionsScreen extends StatelessWidget {
  const FrugalMonthTransactionsScreen({super.key, required this.transactions});
  final Map<LocalDate, List<PastTransaction>> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Center(
        child: TransactionsList(
          transactions: transactions,
          headerBuilder: (date) => DateHeader(date: date),
        ),
      ),
    );
  }
}
