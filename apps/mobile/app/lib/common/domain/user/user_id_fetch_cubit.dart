import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../app/error_reporting/error_reporter.dart';
import '../../../external/http_client.dart';
import '../../../features/auth/domain/models/user.dart';
import '../../../features/auth/domain/use_cases/upsert_user.dart';
import '../../../features/auth/domain/use_cases/watch_has_ynab_access_token.dart';
import '../../../features/auth/domain/use_cases/watch_is_user_logged_in.dart';
import '../../../features/auth/domain/use_cases/watch_user.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/typedefs.dart';

class UserIdFetchCubit extends Cubit<Async<String>> {
  UserIdFetchCubit({
    required WatchIsUserLoggedIn watchIsUserLoggedIn,
    required WatchHasYnabAccessToken watchHasYnabAccessToken,
    required WatchUser watchUser,
    required UpsertUser upsertUser,
    required ErrorReporter errorReporter,
    required Settings settings,
    required HttpClient client,
  }) : _client = client,
       _settings = settings,
       _errorReporter = errorReporter,
       _watchIsUserLoggedIn = watchIsUserLoggedIn,
       _watchHasYnabAccessToken = watchHasYnabAccessToken,
       _watchUser = watchUser,
       _upsertUser = upsertUser,
       super(const Idle()) {
    unawaited(fetch());
  }

  factory UserIdFetchCubit.create() {
    return UserIdFetchCubit(
      watchIsUserLoggedIn: WatchIsUserLoggedIn.create(),
      watchHasYnabAccessToken: WatchHasYnabAccessToken.create(),
      watchUser: WatchUser.create(),
      upsertUser: UpsertUser.create(),
      errorReporter: inject(),
      settings: inject(),
      client: inject(ynabHttpClient),
    );
  }

  final WatchIsUserLoggedIn _watchIsUserLoggedIn;
  final WatchHasYnabAccessToken _watchHasYnabAccessToken;
  final WatchUser _watchUser;
  final UpsertUser _upsertUser;
  final ErrorReporter _errorReporter;
  final Settings _settings;
  final HttpClient _client;

  final subs = CompositeSubscription();
  final _cancelToken = CancelToken();

  Future<void> fetch() async {
    if (subs.isNotEmpty) await subs.clear();

    final fetchSub =
        Rx.combineLatest2(
              _watchIsUserLoggedIn(),
              _watchHasYnabAccessToken(),
              (bool isLoggedIn, bool hasAccessToken) => isLoggedIn && hasAccessToken,
            )
            .switchMap((canHitYnab) async* {
              if (canHitYnab) {
                yield const Loading<String>();
                final response = await _client.execute<Map<String, dynamic>>(
                  GetRequest('/user', cancelToken: _cancelToken),
                );

                switch (response) {
                  case SuccessResponse<Json>():
                    final $json = response.response.data!;
                    final userResponse = UserResponseMapper.fromMap($json);
                    final userId = userResponse.data.user.id;
                    await _settings.setYnabUserId(userId);
                    yield Loaded<String>(userId);
                  case ErrorResponse<Json>():
                    yield Error<String>(response.error);
                }
              } else {
                yield const Idle<String>();
              }
            })
            .listen(safeEmit);
    subs.add(fetchSub);

    final ynabUserIdStream = _settings.watchYnabUserId();
    final userStream = _watchUser();

    final writeSub = Rx.combineLatest2(ynabUserIdStream, userStream, (a, b) => (a, b))
        .distinct()
        .listen((event) async {
          final (ynabUserId, user) = event;
          if (ynabUserId == null) return;
          await _errorReporter.setUserIdentifier(ynabUserId);

          switch (user) {
            case AuthenticatedUser(:final email, :final id):
              await _upsertUser(ynabUserId: ynabUserId, email: email, id: id);
              return;
            case UnauthenticatedUser():
              return;
          }
        });
    subs.add(writeSub);
  }

  @override
  Future<void> close() async {
    _cancelToken.cancel();
    await subs.dispose();
    return super.close();
  }
}
