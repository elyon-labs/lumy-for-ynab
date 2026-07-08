import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../persistence/settings.dart';
import '../../../../../utils/_cubit.dart';
import '../../../domain/models/user.dart';
import '../../../domain/use_cases/change_email.dart';
import '../../../domain/use_cases/watch_user.dart';
import 'change_email_screen_state.dart';

class ChangeEmailScreenCubit extends Cubit<ChangeEmailScreenState> {
  ChangeEmailScreenCubit({
    required ChangeEmail changeEmail,
    required WatchUser watchUser,
    required Settings settings,
  }) : _changeEmail = changeEmail,
       _watchUser = watchUser,
       _settings = settings,
       super(ChangeEmailScreenState.initial()) {
    fetch();
  }

  factory ChangeEmailScreenCubit.create() {
    return ChangeEmailScreenCubit(
      changeEmail: ChangeEmail.create(),
      watchUser: WatchUser.create(),
      settings: inject(),
    );
  }

  final ChangeEmail _changeEmail;
  final WatchUser _watchUser;
  final Settings _settings;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = Rx.combineLatest2(_watchUser(), _settings.watchMagicLinkSentTimestamp(), (
      user,
      magicLinkSentTimestamp,
    ) {
      final timeOfResend = magicLinkSentTimestamp.add(const Duration(minutes: 1));
      final currentEmail = switch (user) {
        AuthenticatedUser(:final email) => email,
        UnauthenticatedUser() => null,
      };
      final pendingEmail = switch (user) {
        AuthenticatedUser(:final pendingEmail) => pendingEmail,
        UnauthenticatedUser() => null,
      };

      return state.copyWith(
        currentEmail: currentEmail,
        pendingEmail: pendingEmail,
        timeUntilEmailChangeResend: timeOfResend.difference(DateTime.now()),
      );
    }).listen(safeEmit);
    _subs.add(sub);

    final timerSub = Stream.periodic(const Duration(seconds: 1), (_) {
      final timeUntilResend = state.timeUntilEmailChangeResend;
      if (timeUntilResend > Duration.zero) {
        return state.copyWith(
          timeUntilEmailChangeResend: timeUntilResend - const Duration(seconds: 1),
        );
      }
      return state.copyWith(timeUntilEmailChangeResend: Duration.zero);
    }).listen(safeEmit);
    _subs.add(timerSub);
  }

  Future<Result<void, Exception>> submit(String email) async {
    emit(state.copyWith(changeEmail: const Loading()));
    final result = await _changeEmail(email: email);
    final newState = result.when(
      ok: (_) => state.copyWith(changeEmail: const Idle()),
      err: (error) => state.copyWith(changeEmail: Error(error)),
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
