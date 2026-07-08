import 'package:rxdart/streams.dart';

import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';
import '../models/user.dart';

class WatchIsUserLoggedIn {
  WatchIsUserLoggedIn({required AuthRepository authRepository}) : _authRepository = authRepository;

  factory WatchIsUserLoggedIn.create() {
    return WatchIsUserLoggedIn(authRepository: inject());
  }

  final AuthRepository _authRepository;

  ValueStream<bool> call() {
    return _authRepository.watch.map((u) => u is AuthenticatedUser).shareValue();
  }
}
