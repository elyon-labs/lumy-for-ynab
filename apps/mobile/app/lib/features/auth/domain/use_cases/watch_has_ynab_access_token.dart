import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';
import '../models/user.dart';

class WatchHasYnabAccessToken {
  WatchHasYnabAccessToken({required AuthRepository repository}) : _repository = repository;

  factory WatchHasYnabAccessToken.create() {
    return WatchHasYnabAccessToken(repository: inject());
  }

  final AuthRepository _repository;

  Stream<bool> call() {
    final userStream = _repository.watch;
    return userStream.map(
      (user) => switch (user) {
        AuthenticatedUser(:final accessToken) => accessToken.isSome(),
        UnauthenticatedUser() => false,
      },
    );
  }
}
