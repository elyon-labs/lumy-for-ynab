import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/http_client.dart';
import '../../../features/auth/domain/use_cases/watch_has_ynab_access_token.dart';
import '../../../features/auth/domain/use_cases/watch_is_user_logged_in.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/typedefs.dart';

class BudgetsFetchCubit extends Cubit<Async<List<Budget>>> {
  BudgetsFetchCubit({
    required LocalDatabase database,
    required WatchIsUserLoggedIn watchIsUserLoggedIn,
    required WatchHasYnabAccessToken watchHasYnabAccessToken,
    required HttpClient ynabClient,
  }) : _watchUserIsLoggedIn = watchIsUserLoggedIn,
       _watchHasYnabAccessToken = watchHasYnabAccessToken,
       _ynabClient = ynabClient,
       _database = database,
       super(const Idle()) {
    unawaited(fetch());
  }

  factory BudgetsFetchCubit.create() {
    return BudgetsFetchCubit(
      database: inject(),
      watchIsUserLoggedIn: WatchIsUserLoggedIn.create(),
      watchHasYnabAccessToken: WatchHasYnabAccessToken.create(),
      ynabClient: inject(ynabHttpClient),
    );
  }

  final LocalDatabase _database;
  final HttpClient _ynabClient;
  final WatchIsUserLoggedIn _watchUserIsLoggedIn;
  final WatchHasYnabAccessToken _watchHasYnabAccessToken;
  final _subs = CompositeSubscription();
  final _cancelToken = CancelToken();

  Future<void> fetch() async {
    if (_subs.isNotEmpty) await _subs.clear();

    final fetchSub =
        Rx.combineLatest2<bool, bool, bool>(
              _watchUserIsLoggedIn(),
              _watchHasYnabAccessToken(),
              (bool isLoggedIn, bool hasAccessToken) => isLoggedIn && hasAccessToken,
            )
            .switchMap<Async<List<Budget>>>((isLoggedIn) async* {
              if (isLoggedIn) {
                yield const Loading();
                final response = await _ynabClient.execute<Map<String, dynamic>>(
                  GetRequest('/budgets', cancelToken: _cancelToken),
                );

                switch (response) {
                  case SuccessResponse<Json>():
                    final json = response.response.data!;
                    final budgetsResponse = BudgetsResponseMapper.fromMap(json);
                    await _database.insertBudgets(budgetsResponse.data.budgets);
                    yield Loaded(budgetsResponse.data.budgets);
                  case ErrorResponse<Json>():
                    yield Error(response);
                }
              } else {
                yield const Idle();
              }
            })
            .listen(safeEmit);
    _subs.add(fetchSub);
  }
}
