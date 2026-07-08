import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../common/presentation/design_system/section_body.dart';
import '../../../../common/presentation/transactions/transactions_screen.dart';
import '../state/spend_by_payee_chart_data_cubit.dart';

class SpendByPayeeSource extends StatelessWidget {
  const SpendByPayeeSource({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SpendByPayeeChartDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => _LoadedSource(value),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class _LoadedSource extends StatelessWidget {
  const _LoadedSource(this.value);

  final SpendByPayeeChartData value;

  @override
  Widget build(BuildContext context) {
    final children = value.payeeSpendData.sortedBySpendAsc
        // Don't bother showing payees with no spend
        .where((e) => e.spend != 0)
        .mapIndexed((i, e) {
          return ListRow(
            title: Text(e.name),
            trailing: HLayout(
              spacing: 0,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(e.spend.format(context.watch<CurrencyFormatCubit>().state)),
                const HSpace(),
                const Icon(Ionicons.chevron_forward_outline, size: Sizes.unit * 2.5).opacity(0.25),
              ],
            ),
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return TransactionsScreen(
                    title: Text(e.name),
                    transactions: value.payeesToTransactions[e.payee] ?? $Map.empty(),
                  );
                },
              ),
            ),
          );
        });
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
      child: ListSection(children: children.toList()),
    );
  }
}
