import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'transaction_row.dart';

class TransactionsList<T> extends HookWidget {
  const TransactionsList({
    super.key,
    required this.transactions,
    required this.headerBuilder,
    this.controller,
  });

  final ScrollController? controller;
  final Map<T, List<BasePastTransaction>> transactions;
  final Widget Function(T key) headerBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
      itemCount: transactions.entries.length,
      itemBuilder: (context, index) {
        final entry = transactions.entries.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.unit * 2),
          child: VLayout(
            spacing: 0,
            children: [
              VEdgePadding(
                child: HEdgePadding(
                  child: DefaultTextStyle.merge(
                    style: context.text.title,
                    child: headerBuilder(entry.key),
                  ),
                ),
              ),
              VLayout(children: entry.value.map((t) => TransactionRow(transaction: t)).toList()),
            ],
          ),
        );
      },
    );
  }
}
