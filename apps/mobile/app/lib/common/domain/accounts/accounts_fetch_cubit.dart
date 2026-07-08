import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/http_client.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/typedefs.dart';

class AccountsFetchCubit extends Cubit<Async<List<Account>>> {
  AccountsFetchCubit({required this.settings, required this.client, required this.database})
    : super(const Idle()) {
    unawaited(fetch());
  }

  factory AccountsFetchCubit.create() {
    return AccountsFetchCubit(
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
        .switchMap<Async<List<Account>>>(($budgetId) async* {
          if ($budgetId.isSome()) {
            final budgetId = $budgetId.unwrap();
            yield const Loading();
            final lastKnowledge = await database.getAccountKnowledge(budgetId: budgetId);
            final response = await client.execute<Json>(
              GetRequest(
                '/budgets/$budgetId/accounts',
                queryParameters: {
                  if (lastKnowledge != null) //
                    'last_knowledge_of_server': lastKnowledge,
                },
              ),
            );

            switch (response) {
              case SuccessResponse<Json>():
                final json = response.response.data!;
                final parsed = AccountsResponseMapper.fromMap(json);
                if (parsed.data.accounts.isEmpty) {
                  await database.updateAccountKnowledge(
                    parsed.data.serverKnowledge,
                    budgetId: budgetId,
                  );
                } else {
                  await database.insertAccounts(
                    parsed.data.accounts,
                    budgetId: budgetId,
                    knowledge: parsed.data.serverKnowledge,
                  );
                }
                yield Loaded(parsed.data.accounts.toList());
              case ErrorResponse<Json>(:final error):
                yield Error(error);
            }
          }
        })
        .listen(safeEmit);
    subs.add(sub);
  }
}
