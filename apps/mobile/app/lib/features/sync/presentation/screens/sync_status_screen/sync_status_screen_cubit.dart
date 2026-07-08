import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../utils/_cubit.dart';
import '../../../../auth/domain/use_cases/link_email.dart';
import '../../../../auth/domain/use_cases/watch_user.dart';
import '../../../domain/use_cases/watched_has_unsynced_data.dart';
import 'sync_status_screen_state.dart';

class SyncStatusScreenCubit extends Cubit<SyncStatusScreenState> {
  SyncStatusScreenCubit({
    required WatchUser watchSyncUser,
    required WatchHasUnsyncedData hasUnsyncedData,
    required LinkEmail linkEmail,
  }) : _watchUser = watchSyncUser,
       _watchHasUnsyncedData = hasUnsyncedData,
       _linkEmail = linkEmail,
       super(SyncStatusScreenState.initial()) {
    fetch();
  }

  factory SyncStatusScreenCubit.create() {
    return SyncStatusScreenCubit(
      watchSyncUser: WatchUser.create(),
      hasUnsyncedData: WatchHasUnsyncedData.create(),
      linkEmail: LinkEmail.create(),
    );
  }

  final WatchUser _watchUser;
  final WatchHasUnsyncedData _watchHasUnsyncedData;
  final LinkEmail _linkEmail;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = Rx.combineLatest2(_watchUser(), _watchHasUnsyncedData(), (user, hasUnsyncedData) {
      return state.copyWith(user: Loaded(user), hasUnsyncedData: hasUnsyncedData);
    }).distinct().listen(safeEmit);
    _subs.add(sub);
  }

  Future<Result<void, Exception>> linkEmail({required String email}) {
    return _linkEmail(email: email);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
