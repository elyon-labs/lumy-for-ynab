import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';
import '../models/user.dart';

class WatchUser {
  WatchUser({required AuthRepository authRepository}) : _authRepository = authRepository;

  factory WatchUser.create() {
    return WatchUser(authRepository: inject());
  }

  final AuthRepository _authRepository;

  Stream<User> call() {
    return _authRepository.watch;
  }
}
