import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:time_machine/time_machine.dart';

import '../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../common/domain/calculations/income_expense/fn.dart';
import '../../../common/presentation/_int.dart';
import '../../../common/presentation/currency.dart';
import '../../../common/presentation/design_system/list_row.dart';
import '../../../common/presentation/design_system/section_body.dart';
import '../state/income_expense_report_cubit.dart';
import 'expense_transactions_for_category_screen.dart';

class ExpenseTransactionsScreen extends HookWidget {
  const ExpenseTransactionsScreen({super.key, required this.month});
  final LocalDate month;

  static String buildRoute(LocalDate month) {
    final monthString = month.toString('yyyy-MM');
    return '/reports/income_expense/expense_transactions/$monthString';
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<IncomeExpenseReportCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text('${month.monthOfYear.toMonthName()} Expenses')),
      body: switch (data) {
        Loaded(:final value) => _LoadedBody(month: month, data: value),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.month, required this.data});

  final LocalDate month;
  final IncomeExpenseData data;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final monthData = data.monthData.singleWhere((m) => m.month == month);
    final categoriesToTransactions = monthData.categoriesToTransactions;
    final categoriesToExpense = monthData.categoriesToExpense.sortByValues();

    String label(int numberTransactions) {
      return numberTransactions == 1 ? 'transaction' : 'transactions';
    }

    final rows = categoriesToExpense.entries
        .map(
          (e) => ListRow(
            title: Text(e.key.name),
            subtitle: Builder(
              builder: (context) {
                final number = categoriesToTransactions[e.key]!.length;
                return Text('$number ${label(number)}');
              },
            ),
            trailing: HLayout(
              spacing: 0,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(e.value.format(currencyFormat)),
                const HSpace(),
                const Icon(Ionicons.chevron_forward_outline, size: Sizes.unit * 2.5).opacity(0.25),
              ],
            ),
            onTap: () => GoRouter.of(
              context,
            ).go(ExpenseTransactionsForCategoryScreen.buildRoute(month, e.key.id)),
          ),
        )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
      child: ListSection(children: rows),
    );
  }
}
