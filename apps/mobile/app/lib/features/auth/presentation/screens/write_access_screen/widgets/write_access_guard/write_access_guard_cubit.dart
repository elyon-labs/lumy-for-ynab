import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../utils/_cubit.dart';
import '../../../../../domain/use_cases/watch_has_ynab_write_access.dart';

class WriteAccessGuardCubit extends Cubit<Async<bool>> {
  WriteAccessGuardCubit({required WatchHasYnabWriteAccess watchHasYnabWriteAccess})
    : _watchHasYnabWriteAccess = watchHasYnabWriteAccess,
      super(const Loading()) {
    fetch();
  }

  factory WriteAccessGuardCubit.create() {
    return WriteAccessGuardCubit(watchHasYnabWriteAccess: WatchHasYnabWriteAccess.create());
  }

  final WatchHasYnabWriteAccess _watchHasYnabWriteAccess;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = _watchHasYnabWriteAccess().listen((hasAccess) => safeEmit(Loaded(hasAccess)));
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
