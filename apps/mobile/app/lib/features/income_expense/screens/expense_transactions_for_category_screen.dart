import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../common/domain/calculations/income_expense/fn.dart';
import '../../../common/domain/worker/_transactions_async.dart';
import '../../../common/presentation/transactions/date_header.dart';
import '../../../common/presentation/transactions/transaction_list.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/hooks/hook_bloc_builder.dart';
import '../../../utils/hooks/use_cubit_connect.dart';
import '../../../utils/sort.dart';
import '../state/income_expense_report_cubit.dart';
import 'expense_transactions_screen.dart';

class ExpenseTransactionsForCategoryScreenState {
  ExpenseTransactionsForCategoryScreenState({
    required this.category,
    required this.transactions,
    required this.categoryId,
  });

  factory ExpenseTransactionsForCategoryScreenState.initial(String categoryId) {
    return ExpenseTransactionsForCategoryScreenState(
      categoryId: categoryId,
      category: const Loading(),
      transactions: {},
    );
  }

  final String categoryId;
  final Async<Category> category;
  final Map<LocalDate, List<PastTransaction>> transactions;
}

class ExpenseTransactionsForCategoryScreenCubit
    extends Cubit<ExpenseTransactionsForCategoryScreenState> {
  ExpenseTransactionsForCategoryScreenCubit({required this.categoryId, required this.month})
    : super(ExpenseTransactionsForCategoryScreenState.initial(categoryId));

  factory ExpenseTransactionsForCategoryScreenCubit.create({
    required String categoryId,
    required LocalDate month,
  }) {
    return ExpenseTransactionsForCategoryScreenCubit(categoryId: categoryId, month: month);
  }

  final String categoryId;
  final LocalDate month;

  Future<void> update(Async<IncomeExpenseData> data) async {
    if (data is Loaded) {
      final monthData = data.unwrap().monthData.singleWhere((m) => m.month == month);
      final category = monthData.categoriesToTransactions.keys.singleWhere(
        (p) => p.id == categoryId,
      );
      final transactions = monthData.categoriesToTransactions[category] ?? [];
      safeEmit(
        ExpenseTransactionsForCategoryScreenState(
          category: Loaded(category),
          transactions: await transactions.groupByDate(dateDesc),
          categoryId: categoryId,
        ),
      );
    }
  }
}

class ExpenseTransactionsForCategoryScreen extends HookWidget {
  const ExpenseTransactionsForCategoryScreen({
    super.key,
    required this.month,
    required this.categoryId,
  });

  final String categoryId;
  final LocalDate month;

  static String buildRoute(LocalDate month, String categoryId) {
    return '${ExpenseTransactionsScreen.buildRoute(month)}/category/$categoryId';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ExpenseTransactionsForCategoryScreenCubit.create(categoryId: categoryId, month: month),
      child:
          HookBlocBuilder<
            ExpenseTransactionsForCategoryScreenCubit,
            ExpenseTransactionsForCategoryScreenState
          >(
            builder: (context, state) {
              useCubitConnect<
                IncomeExpenseReportCubit,
                ExpenseTransactionsForCategoryScreenCubit,
                Async<IncomeExpenseData>
              >(
                onStateChange: (cubit, state) async => await cubit.update(state),
                keys: [month, categoryId],
              );
              return Scaffold(
                appBar: AppBar(
                  title: Text(switch (state.category) {
                    Loaded(:final value) => value.name,
                    _ => 'Loading...',
                  }),
                ),
                body: TransactionsList(
                  transactions: state.transactions,
                  headerBuilder: (date) => DateHeader(date: date),
                ),
              );
            },
          ),
    );
  }
}
