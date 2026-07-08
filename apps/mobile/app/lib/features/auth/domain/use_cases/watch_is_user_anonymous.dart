import 'package:rxdart/streams.dart';

import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';
import '../models/user.dart';

class WatchIsUserAnonymous {
  WatchIsUserAnonymous({required AuthRepository authRepository}) : _authRepository = authRepository;

  factory WatchIsUserAnonymous.create() {
    return WatchIsUserAnonymous(authRepository: inject());
  }

  final AuthRepository _authRepository;

  ValueStream<bool> call() {
    return _authRepository.watch.map((u) => u is AuthenticatedUser && u.isAnonymous).shareValue();
  }
}
