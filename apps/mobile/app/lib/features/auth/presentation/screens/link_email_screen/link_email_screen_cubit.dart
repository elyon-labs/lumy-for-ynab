import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../persistence/settings.dart';
import '../../../../../utils/_cubit.dart';
import '../../../domain/use_cases/link_email.dart';
import '../../../domain/use_cases/log_in_anonymously.dart';
import '../../../domain/use_cases/log_in_with_email.dart';
import '../../../domain/use_cases/log_in_with_email_and_password.dart';
import '../../../domain/use_cases/watch_is_user_anonymous.dart';
import '../../../domain/use_cases/watch_is_user_logged_in.dart';
import 'link_email_screen_state.dart';

class LinkEmailScreenCubit extends Cubit<LinkEmailScreenState> {
  LinkEmailScreenCubit({
    required this.isExistingUser,
    required LogInWithEmail logInWithEmail,
    required LogInWithEmailAndPassword logInWithEmailAndPassword,
    required LinkEmail linkEmail,
    required LogInAnonymously logInAnonymously,
    required WatchIsUserLoggedIn watchIsUserLoggedIn,
    required WatchIsUserAnonymous watchIsUserAnonymous,
    required Settings settings,
  }) : _logInWithEmail = logInWithEmail,
       _logInWithEmailAndPassword = logInWithEmailAndPassword,
       _linkEmail = linkEmail,
       _logInAnonymously = logInAnonymously,
       _watchIsUserLoggedIn = watchIsUserLoggedIn,
       _watchIsUserAnonymous = watchIsUserAnonymous,
       _settings = settings,
       super(LinkEmailScreenState.initial(isExistingUser: isExistingUser)) {
    fetch();
  }

  factory LinkEmailScreenCubit.create({required bool isExistingUser}) {
    return LinkEmailScreenCubit(
      isExistingUser: isExistingUser,
      logInWithEmail: LogInWithEmail.create(),
      logInWithEmailAndPassword: LogInWithEmailAndPassword.create(),
      linkEmail: LinkEmail.create(),
      logInAnonymously: LogInAnonymously.create(),
      watchIsUserLoggedIn: WatchIsUserLoggedIn.create(),
      watchIsUserAnonymous: WatchIsUserAnonymous.create(),
      settings: inject(),
    );
  }

  final bool isExistingUser;
  final LogInWithEmail _logInWithEmail;
  final LogInWithEmailAndPassword _logInWithEmailAndPassword;
  final LinkEmail _linkEmail;
  final LogInAnonymously _logInAnonymously;
  final WatchIsUserLoggedIn _watchIsUserLoggedIn;
  final WatchIsUserAnonymous _watchIsUserAnonymous;
  final Settings _settings;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = Rx.combineLatest3(
      _watchIsUserLoggedIn(),
      _watchIsUserAnonymous(),
      _settings.watchMagicLinkSentTimestamp(),
      (isLoggedIn, isAnonymous, magicLinkSentTimestamp) {
        // An email can be sent every minute
        final timeOfResend = magicLinkSentTimestamp.add(const Duration(minutes: 1));

        return state.copyWith(
          isUserLoggedIn: isLoggedIn,
          isUserAnonymous: isAnonymous,
          timeUntilMagicLinkResend: timeOfResend.difference(DateTime.now()),
        );
      },
    ).listen(safeEmit);

    _subs.add(sub);

    final magicLinkSub = Stream.periodic(const Duration(seconds: 1), (_) {
      final timeUntilMagicLinkResend = state.timeUntilMagicLinkResend;
      if (timeUntilMagicLinkResend > Duration.zero) {
        return state.copyWith(
          timeUntilMagicLinkResend: timeUntilMagicLinkResend - const Duration(seconds: 1),
        );
      }
      return state.copyWith(timeUntilMagicLinkResend: Duration.zero);
    }).listen(safeEmit);

    _subs.add(magicLinkSub);
  }

  Future<Result<void, Exception>> logInWithEmail(String email) async {
    emit(state.copyWith(login: const Loading()));
    final result = await _logInWithEmail(email: email);
    final newState = result.when(
      ok: (_) {
        return state.copyWith(login: const Idle());
      },
      err: (error) {
        return state.copyWith(login: Error(error));
      },
    );
    safeEmit(newState);
    return result;
  }

  Future<Result<void, Exception>> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(login: const Loading()));
    final result = await _logInWithEmailAndPassword(email: email, password: password);
    final newState = result.when(
      ok: (_) {
        return state.copyWith(login: const Idle());
      },
      err: (error) {
        return state.copyWith(login: Error(error));
      },
    );
    safeEmit(newState);
    return result;
  }

  Future<Result<void, Exception>> linkEmail(String email) async {
    emit(state.copyWith(login: const Loading()));
    final result = await _linkEmail(email: email);
    final newState = result.when(
      ok: (_) {
        return state.copyWith(login: const Idle());
      },
      err: (error) {
        return state.copyWith(login: Error(error));
      },
    );
    safeEmit(newState);
    return result;
  }

  Future<Result<void, Exception>> logInAnonymously() async {
    emit(state.copyWith(login: const Loading()));
    final result = await _logInAnonymously();
    final newState = result.when(
      ok: (_) {
        return state.copyWith(login: const Idle());
      },
      err: (error) {
        return state.copyWith(login: Error(error));
      },
    );
    safeEmit(newState);
    return result;
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
