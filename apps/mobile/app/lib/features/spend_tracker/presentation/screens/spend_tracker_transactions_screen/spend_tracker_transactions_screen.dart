import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/presentation/transactions/date_header.dart';
import '../../../../../common/presentation/transactions/transaction_list.dart';
import 'spend_tracker_transactions_screen_cubit.dart';
import 'spend_tracker_transactions_screen_state.dart';

class SpendTrackerTransactionsScreen extends StatelessWidget {
  const SpendTrackerTransactionsScreen({super.key, required this.spendTrackerId});

  final String spendTrackerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SpendTrackerTransactionsScreenCubit.create(spendTrackerId: spendTrackerId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Transactions')),
        body: _Body(spendTrackerId: spendTrackerId),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.spendTrackerId});
  final String spendTrackerId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendTrackerTransactionsScreenCubit, SpendTrackerTransactionsScreenState>(
      builder: (context, state) {
        return switch (state.spendTrackerData) {
          Loaded(:final value) => TransactionsList(
            transactions: value.monthsToTransactions,
            headerBuilder: (date) => DateHeader(date: date),
          ),
          _ => const Center(child: CircularProgressIndicator.adaptive()),
        };
      },
    );
  }
}
