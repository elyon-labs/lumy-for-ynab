import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'date_header.dart';
import 'transaction_list.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, required this.title, required this.transactions});

  final Widget title;
  final Map<LocalDate, List<PastTransaction>> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title),
      body: transactions.isEmpty ? const _Empty() : _Body(transactions: transactions),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.transactions});

  final Map<LocalDate, List<PastTransaction>> transactions;

  @override
  Widget build(BuildContext context) {
    return TransactionsList(
      transactions: transactions,
      headerBuilder: (date) => DateHeader(date: date),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VLayout(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welp,\nnothing to see here.',
            textAlign: TextAlign.center,
            style: context.text.title,
          ),
        ],
      ),
    );
  }
}
