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

class PayeesFetchCubit extends Cubit<Async<List<Payee>>> {
  PayeesFetchCubit({required this.settings, required this.client, required this.database})
    : super(const Idle()) {
    unawaited(fetch());
  }

  factory PayeesFetchCubit.create() {
    return PayeesFetchCubit(settings: inject(), client: inject(ynabHttpClient), database: inject());
  }

  final Settings settings;
  final LocalDatabase database;
  final HttpClient client;
  final subs = CompositeSubscription();

  Future<void> fetch() async {
    if (subs.isNotEmpty) await subs.clear();

    final sub = settings
        .watchSelectedBudgetId()
        .switchMap<Async<List<Payee>>>(($budgetId) async* {
          if ($budgetId.isSome()) {
            final budgetId = $budgetId.unwrap();
            yield const Loading();
            final lastKnowledge = await database.getPayeeKnowledge(budgetId: budgetId);
            final response = await client.execute<Json>(
              GetRequest(
                '/budgets/$budgetId/payees',
                queryParameters: {
                  if (lastKnowledge != null) //
                    'last_knowledge_of_server': lastKnowledge,
                },
              ),
            );

            switch (response) {
              case SuccessResponse<Json>():
                final json = response.response.data!;
                final parsed = PayeesResponseMapper.fromMap(json);
                if (parsed.data.payees.isEmpty) {
                  await database.updatePayeeKnowledge(
                    parsed.data.serverKnowledge,
                    budgetId: budgetId,
                  );
                } else {
                  await database.insertPayees(
                    parsed.data.payees,
                    budgetId: budgetId,
                    knowledge: parsed.data.serverKnowledge,
                  );
                }
                yield Loaded(parsed.data.payees.toList());
              case ErrorResponse<Json>(:final error):
                yield Error(error);
            }
          }
        })
        .listen(safeEmit);
    subs.add(sub);
  }
}
