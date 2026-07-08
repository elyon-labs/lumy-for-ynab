import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/http_client.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_date_time.dart';
import '../../../utils/typedefs.dart';

class TransactionsFetchState {
  TransactionsFetchState({
    required this.isInitialFetch,
    required this.transactions,
    required this.lastFetch,
  });

  factory TransactionsFetchState.initial() {
    return TransactionsFetchState(
      lastFetch: DateTime(0),
      isInitialFetch: false,
      transactions: const Idle(),
    );
  }

  final DateTime lastFetch;
  final bool isInitialFetch;
  final Async<List<PastTransaction>> transactions;
}

const _fullTransactionHistorySinceDate = '1900-01-01';

class TransactionsFetchCubit extends Cubit<TransactionsFetchState> {
  TransactionsFetchCubit({required this.settings, required this.client, required this.database})
    : super(TransactionsFetchState.initial()) {
    unawaited(fetch());
  }

  factory TransactionsFetchCubit.create() {
    return TransactionsFetchCubit(
      settings: inject(),
      client: inject(ynabHttpClient),
      database: inject(),
    );
  }

  final Settings settings;
  final HttpClient client;
  final LocalDatabase database;
  final subs = CompositeSubscription();

  Future<void> fetch() async {
    if (subs.isNotEmpty) await subs.clear();

    final fetchStream = settings.watchSelectedBudgetId().switchMap(($budgetId) async* {
      if ($budgetId.isSome()) {
        final budgetId = $budgetId.unwrap();
        await _ensureFullTransactionHistoryWillBeFetched();
        final lastKnowledge = await database.getTransactionKnowledge(budgetId: budgetId);
        yield TransactionsFetchState(
          lastFetch: state.lastFetch,
          isInitialFetch: lastKnowledge == null,
          transactions: const Loading(),
        );
        final response = await client.execute<Json>(
          GetRequest(
            '/budgets/$budgetId/transactions',
            queryParameters: {
              if (lastKnowledge != null)
                'last_knowledge_of_server': lastKnowledge
              else
                'since_date': _fullTransactionHistorySinceDate,
            },
          ),
        );

        switch (response) {
          case SuccessResponse<Json>():
            final json = response.response.data!;
            final parsed = await compute(TransactionsResponseMapper.fromMap, json);
            if (parsed.data.transactions.isEmpty) {
              await database.updateTransactionKnowledge(
                parsed.data.serverKnowledge,
                budgetId: budgetId,
              );
            } else {
              await database.insertTransactions(
                parsed.data.transactions,
                budgetId: budgetId,
                knowledge: parsed.data.serverKnowledge,
              );
            }
            yield TransactionsFetchState(
              lastFetch: state.lastFetch,
              isInitialFetch: false,
              transactions: Loaded(parsed.data.transactions.toList()),
            );
            settings.setLastFetch(nowLocal);
          case ErrorResponse<Json>(:final error):
            yield TransactionsFetchState(
              lastFetch: state.lastFetch,
              isInitialFetch: false,
              transactions: Error(error),
            );
        }
      }
    });
    final lastFetchStream = settings.watchLastFetch().map((event) {
      return TransactionsFetchState(
        isInitialFetch: state.isInitialFetch,
        transactions: state.transactions,
        lastFetch: event,
      );
    });
    final sub = Rx.combineLatest2(fetchStream, lastFetchStream, (a, b) => (a, b)).listen((event) {
      final (fetchState, lastFetch) = event;
      safeEmit(
        TransactionsFetchState(
          isInitialFetch: fetchState.isInitialFetch,
          transactions: fetchState.transactions,
          lastFetch: lastFetch.lastFetch,
        ),
      );
    });
    subs.add(sub);
  }

  Future<void> _ensureFullTransactionHistoryWillBeFetched() async {
    final hasForcedRefetch = await settings.hasForcedFullTransactionRefetchForYnabSinceDateChange();
    if (hasForcedRefetch) return;

    await database.deleteTransactionKnowledges();
    await settings.setHasForcedFullTransactionRefetchForYnabSinceDateChange();
  }
}
