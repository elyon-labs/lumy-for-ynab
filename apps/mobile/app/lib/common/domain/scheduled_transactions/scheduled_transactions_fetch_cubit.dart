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
import '../../../utils/typedefs.dart';

class ScheduledTransactionsFetchCubit extends Cubit<Async<List<ScheduledTransaction>>> {
  ScheduledTransactionsFetchCubit({
    required this.settings,
    required this.client,
    required this.database,
  }) : super(const Idle()) {
    unawaited(fetch());
  }

  factory ScheduledTransactionsFetchCubit.create() {
    return ScheduledTransactionsFetchCubit(
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

    final sub = settings
        .watchSelectedBudgetId()
        .switchMap(($budgetId) async* {
          if ($budgetId.isSome()) {
            final budgetId = $budgetId.unwrap();
            final lastKnowledge = await database.getScheduledTransactionKnowledge(
              budgetId: budgetId,
            );
            yield const Loading<List<ScheduledTransaction>>();
            final response = await client.execute<Json>(
              GetRequest(
                '/budgets/$budgetId/scheduled_transactions',
                queryParameters: {
                  if (lastKnowledge != null) //
                    'last_knowledge_of_server': lastKnowledge,
                },
              ),
            );

            switch (response) {
              case SuccessResponse<Json>():
                final json = response.response.data!;
                final parsed = await compute(ScheduledTransactionsResponseMapper.fromMap, json);
                if (parsed.data.scheduledTransactions.isEmpty) {
                  await database.updateScheduledTransactionKnowledge(
                    parsed.data.serverKnowledge,
                    budgetId: budgetId,
                  );
                } else {
                  await database.insertScheduledTransactions(
                    parsed.data.scheduledTransactions,
                    budgetId: budgetId,
                    knowledge: parsed.data.serverKnowledge,
                  );
                }
                yield Loaded(parsed.data.scheduledTransactions.toList());
              case ErrorResponse<Json>(:final error):
                yield Error<List<ScheduledTransaction>>(error);
            }
          }
        })
        .listen(safeEmit);
    subs.add(sub);
  }
}
