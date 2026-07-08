import 'package:dart_foundation/dart_foundation.dart';

import 'watch_is_user_logged_in.dart';

class IsUserLoggedIn {
  IsUserLoggedIn({required WatchIsUserLoggedIn watchIsUserLoggedIn})
    : _watchIsUserLoggedIn = watchIsUserLoggedIn;

  factory IsUserLoggedIn.create() {
    return IsUserLoggedIn(watchIsUserLoggedIn: WatchIsUserLoggedIn.create());
  }

  final WatchIsUserLoggedIn _watchIsUserLoggedIn;

  Future<bool> call() async {
    return _watchIsUserLoggedIn().nextValue();
  }
}
