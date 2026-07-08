import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
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
import 'income_transactions_screen.dart';

class IncomeTransactionsForPayeeScreenState {
  IncomeTransactionsForPayeeScreenState({
    required this.payee,
    required this.transactions,
    required this.payeeId,
  });

  factory IncomeTransactionsForPayeeScreenState.initial(String? payeeId) {
    return IncomeTransactionsForPayeeScreenState(
      payeeId: payeeId,
      payee: const Loading(),
      transactions: {},
    );
  }

  final String? payeeId;
  final Async<Option<Payee>> payee;
  final Map<LocalDate, List<PastTransaction>> transactions;
}

class IncomeTransactionsForPayeeScreenCubit extends Cubit<IncomeTransactionsForPayeeScreenState> {
  IncomeTransactionsForPayeeScreenCubit({required this.payeeId, required this.month})
    : super(IncomeTransactionsForPayeeScreenState.initial(payeeId));

  factory IncomeTransactionsForPayeeScreenCubit.create({
    required String? payeeId,
    required LocalDate month,
  }) {
    return IncomeTransactionsForPayeeScreenCubit(payeeId: payeeId, month: month);
  }

  final String? payeeId;
  final LocalDate month;

  Future<void> update(Async<IncomeExpenseData> data) async {
    if (data is Loaded) {
      final monthData = data.unwrap().monthData.singleWhere((m) => m.month == month);
      final payee = payeeId == noPayeeIdToken
          ? const None<Payee>() //
          : monthData.payeesToTransactions.keys.firstWhere((p) => p.unwrap().id == payeeId);
      final transactions = monthData.payeesToTransactions[payee] ?? [];
      safeEmit(
        IncomeTransactionsForPayeeScreenState(
          payee: Loaded(payee),
          transactions: await transactions.groupByDate(dateDesc),
          payeeId: payeeId,
        ),
      );
    }
  }
}

const noPayeeIdToken = 'no-payee-id';

extension on Option<String> {
  String get valueOrNoPayeeId {
    return mapOr((i) => i, noPayeeIdToken);
  }
}

class IncomeTransactionsForPayeeScreen extends HookWidget {
  const IncomeTransactionsForPayeeScreen({super.key, required this.month, required this.payeeId});

  final String payeeId;
  final LocalDate month;

  static String buildRoute(LocalDate month, Option<String> payeeId) {
    final resolvedPayeeId = payeeId.valueOrNoPayeeId;
    return '${IncomeTransactionsScreen.buildRoute(month)}/payee/$resolvedPayeeId';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncomeTransactionsForPayeeScreenCubit.create(payeeId: payeeId, month: month),
      child:
          HookBlocBuilder<
            IncomeTransactionsForPayeeScreenCubit,
            IncomeTransactionsForPayeeScreenState
          >(
            builder: (context, state) {
              useCubitConnect<
                IncomeExpenseReportCubit,
                IncomeTransactionsForPayeeScreenCubit,
                Async<IncomeExpenseData>
              >(
                onStateChange: (cubit, state) async => await cubit.update(state),
                keys: [month, payeeId],
              );
              return Scaffold(
                appBar: AppBar(
                  title: Text(switch (state.payee) {
                    Loaded(:final value) => value.mapOr((p) => p.name, 'No Payee'),
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
