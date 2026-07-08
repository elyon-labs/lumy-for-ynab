import '../../../../app/di.dart';
import '../../../../ynab_api/oauth/ynab_access_token.dart';
import '../../data/repositories/auth_repository.dart';
import '../models/user.dart';

class WatchHasYnabWriteAccess {
  WatchHasYnabWriteAccess({required AuthRepository repository}) : _repository = repository;

  factory WatchHasYnabWriteAccess.create() {
    return WatchHasYnabWriteAccess(repository: inject());
  }

  final AuthRepository _repository;

  Stream<bool> call() {
    final userStream = _repository.watch;
    return userStream.map(
      (user) => switch (user) {
        AuthenticatedUser(:final accessToken) => accessToken.mapOr((t) => t.hasWriteAccess, false),
        UnauthenticatedUser() => false,
      },
    );
  }
}
