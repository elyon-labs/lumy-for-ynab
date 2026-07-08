import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../common/presentation/design_system/section_body.dart';
import '../../../../common/presentation/transactions/transactions_screen.dart';
import '../../models/chart.dart';
import '../state/spend_by_category_chart_data_cubit.dart';

class SpendByCategorySource extends StatelessWidget {
  const SpendByCategorySource({super.key, required this.chart});

  final Chart chart;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SpendByCategoryChartDataCubit>().state;

    return switch (data) {
      Loaded(:final value) => _Source(value: value),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class _Source extends HookWidget {
  const _Source({required this.value});

  final SpendByCategoryData value;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final children = value.categorySpendData.sortedBySpendAsc.mapIndexed((i, e) {
      return ListRow(
        title: Text(e.category.name),
        trailing: HLayout(
          spacing: 0,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(e.spend.format(currencyFormat)),
            const HSpace(),
            const Icon(Ionicons.chevron_forward_outline, size: Sizes.unit * 2.5).opacity(0.25),
          ],
        ),
        onTap: () async => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return TransactionsScreen(
                title: Text(e.category.name),
                transactions: value.categoryToTransactions[e.category] ?? {},
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
